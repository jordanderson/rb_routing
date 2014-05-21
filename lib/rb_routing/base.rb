module RbRouting
  # = RbRouting
  #
  # RbRouting objects primarily consist of:
  # - Parameters used to connect to a pgRouting-enabled postgres database
  # - Methods that define the SQL queries used to call pgRouting's provided shortest path functions
  #
  # Most of pgRouting's shortest path functions require two SQL statements: a cost query 
  # and a results query
  #
  # == Cost query
  # A query that should return a particular set of columns that define key inputs 
  # into the routing function. For example, the Dijkstra algorithm requires:
  # `SELECT id, source, target, cost [,reverse_cost] FROM edge_table` where
  # the reverse_cost column is optional. 
  #
  # This defines the graph that will be analyzed by the shortest path function and 
  # the columns (or expressions) used to calculate the cost of traversing each edge.
  #
  # The cost query is defined by 3 methods:
  # - `cost_query_select` - returns a has containing the fields to select and their aliases
  # - `cost_query_from` - defaults to the `edge_table`
  # - `cost_query_where` - defaults to a blank string. This would allow you to narrow down the
  #   network the shortest path function is searching.
  #
  # == Results query
  # A query that -- most importantly -- calls a pgRouting function with the 
  # required parameters, and then optionally joins that result set to another table
  # or view to enrich the data (e.g. street names, OSM tags, etc.).
  #
  # All of pgRouting's shortest path functions return their results using a custom
  # postgres data type called `pgr_costResult`: 
  # - `seq` - the step number of the path
  # - `id1` - typically the node id 
  # - `id2` - typically the edge id
  # - `cost` - the cost incurred at that step
  class Base 

    include ::RbRouting::RouteOptions

    def set_db_params(options = {})
      connect(options)
    end

    def set_import_params(options = {})
      @clean_tables   ||= options[:clean]       || true
      @skip_nodes     ||= options[:skip_nodes]  || true
      @import_options = {:clean_tables => @clean_tables, :skip_nodes => @skip_nodes}
    end

    # Specify a new instance of {RbRouting::Base}, including any DB params, osm2pgrouting import params, 
    # and routing params
    def initialize(options={})
      set_db_params(options)
      set_import_params(options)
      set_routing_params(options)
    end

    # A connection to the postgres database.
    def db
      @connection.pg rescue nil
    end

    def connection 
      @connection rescue nil
    end

    # Connect to the postgres database.
    def connect(options = {})
      @connection ||= ::RbRouting::Connection.new(options)
    end

    # Display an array of validation or routing errors that have been raised since the last run.
    def errors
      @errors
    end

    # The raw postgres routing function result set as an array.
    def result 
      @result
    end

    # An instance of {RbRouting::Path} (or whatever has been specified in {#path_class}) containing 
    # the shortest path from the last run.
    def path
      @path
    end

    # The class to use for the shortest path results. Default is {RbRouting::Path}.
    def path_class
      RbRouting::Path
    end

    def routing_function_defaults
      "define in subclass"
    end

    def routing_function_definition
      "define in subclass"
    end

    # A hash specifying the select clause of the cost query. By default it is:
    #   {
    #     'id'            => @id_field,
    #     'source'        => @source_field,
    #     'target'        => @target_field,
    #     'cost'          => @cost_field,
    #     'reverse_cost'  => @reverse_cost_field 
    #   }
    def cost_query_select
      {
        'id'            => @id_field,
        'source'        => @source_field,
        'target'        => @target_field,
        'cost'          => @cost_field,
        'reverse_cost'  => @reverse_cost_field 
      }
    end

    # The from clause of the cost query. Defaults to the edge_table.
    def cost_query_from
      @edge_table
    end

    # The where clause of the cost query. Defaults to an empty string.
    def cost_query_where
      ""
    end

    # A hash specifying the select clause of the results query. By default it is:
    #   {
    #     'seq'           => :seq,
    #     'node'          => :id1,
    #     'edge'          => :id2,
    #     'cost'          => :cost,
    #     'reverse_cost'  => :cost
    #   }
    def results_query_select
      {
        'seq'           => :seq,
        'node'          => :id1,
        'edge'          => :id2,
        'cost'          => :cost,
        'reverse_cost'  => :cost
      }
    end

    # The from clause of the results query. Defaults to the shortest path function
    # defined by `routing_function` with the params defined in 
    # `routing_function_params`.
    def results_query_from
      Sequel.function(routing_function, *routing_function_params)
    end

    # The where clause of the results query.
    def results_query_where
      ""
    end

    def cost_query
      select_args = cost_query_select.map {|k,v| Sequel.as(v, k) }
      db.select(*select_args).from(cost_query_from).where(cost_query_where)
    end

    def results_query
      select_args = results_query_select.map {|k,v| Sequel.as(v, k) }
      db.select(*select_args).from(*results_query_from).where(results_query_where)
    end

    def routing_function
      routing_function_definition.keys.first
    end

    def routing_function_params
      routing_function_definition.values.flatten.map {|v| @run_options[v] }.reject {|p| p.nil? }
    end

    # Each shortest path function includes a set of defaults, defined in {#routing_function_defaults}.
    # This method sets defaults for any routing function parameters that have not been explicitly
    # defined when calling {#run}.
    def set_defaults(options = {})
      routing_function_defaults.each do |key, value|
        options[key] = value if options[key].blank? and ![:optional, :required].include?(value) 
      end

      options
    end

    def validations(options = {})
      @errors = []
      routing_function_defaults.each do |key, value|
        @errors << "'#{key}'" if options[key].blank? and value == :required
      end

      raise MissingRoutingParameter, @errors.join(", ") unless @errors.blank? 
      
      @errors
    end

    # Import data into the specified edge_table using osm2pgrouting.
    #
    # Example:<br />
    # `router = RbRouting::Router::TrspByVertex.new :user => "postgres", :password => "postgres", :database => "routing"`<br />
    # `router.import_osm_data "/path/to/san_francisco_osm_file.osm", "/path/to/my/pgrouting/mapconfig.xml"`
    def import_osm_data(file_name, config_file, options={})
      ::RbRouting::import_osm_data(file_name, @db, @user, config_file, options.merge(@db_options).merge(@import_options))
    end

    # Find the shortest path via the cost and results queries built along with any parameters provided.
    #
    #
    # Example:<br />
    # `router = RbRouting::Router::TrspByVertex.new :user => "postgres", :password => "postgres", :database => "routing"`<br />
    # `router.run :source => 550, :target => 5463`
    def run(options = {})
      options = set_defaults(options)
      validations(options)
      @run_options = options

      puts "Routing options: #{options}" if options[:debug]

      begin
        @result = results_query.to_a
        @path = path_class.new @result
      rescue => e
        @errors << "#{e}: #{e.backtrace}"
        return false
      end

      true
    end

  end

end
