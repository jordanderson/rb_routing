module RbRouting #:nodoc:
  # = RbRouting
  #
  # RbRouting objects primarily consist of:
  # - Parameters used to connect to a pgRouting-enabled postgres database
  # - Methods that define the SQL queries used to call pgRouting's provided shortest path functions
  #
  # Most of pgRouting's shortest path functions require two SQL statements:
  #
  # - Cost query - A query that should return a particular set of columns that define key inputs 
  #                into the routing function. For example, the Dijkstra algorithm requires:
  #                ``` SELECT id, source, target, cost [,reverse_cost] FROM edge_table ``` where
  #                the reverse_cost column is optional. 
  #
  #                This defines the graph that will be analyzed by the shortest path function and 
  #                the columns (or expressions) used to calculate the cost of traversing each edge.
  #
  # - Results query - A query that -- most importantly -- calls a pgRouting function with the 
  #                   required parameters, and then optionally joins that result set to another table
  #                   or view to enrich the data (e.g. street names, OSM tags, etc.).
  #
  #                   All of pgRouting's shortest path functions return their results using a custom
  #                   postgres data type called ```pgr_costResult```: 
  #                   ```seq``` - the step number of the path
  #                   ```id1``` - typically the node id 
  #                   ```id2``` - typically the edge id
  #                   ```cost``` - the cost incurred at that step
  #
  class Base 

    def set_db_params(options = {})
      @db           ||= options[:database]
      @host         ||= options[:host]          || "localhost"
      @user         ||= options[:user] 
      @port         ||= options[:port]          || "5432"
      @password     ||= options[:password]
      @table_prefix ||= options[:table_prefix]
      @db_options    = {:database => @db, :host => @host, :user => @user, 
                        :port => @port, :password => @password, :table_prefix => @table_prefix}

      connect
    end

    def set_routing_params(options = {})
      @id_field           ||= options[:id]              || :gid
      @source_field       ||= options[:source]          || :source
      @target_field       ||= options[:target]          || :target
      @cost_field         ||= options[:cost]            || :length
      @reverse_cost_field ||= options[:reverse_cost]    || :length
      @edge_table         ||= options[:edge_table]      || :ways
    end

    def set_import_params(options = {})
      @clean_tables   ||= options[:clean]       || true
      @skip_nodes     ||= options[:skip_nodes]  || true
      @import_options = {:clean_tables => @clean_tables, :skip_nodes => @skip_nodes}
    end

    def initialize(options={})
      set_db_params(options)
      set_import_params(options)
      set_routing_params(options)
    end

    def connection 
      @connection.pg rescue nil
    end

    def connect
      @connection ||= ::RbRouting::Connection.new(@db_options)
    end

    def errors
      @errors
    end

    def result 
      @result
    end

    def path
      @path
    end

    def path_class
      RbRouting::Path
    end

    def routing_function_defaults
      "define in subclass"
    end

    def routing_function_definition
      "define in subclass"
    end

    def cost_query_select
      {
        'id'            => @id_field,
        'source'        => @source_field,
        'target'        => @target_field,
        'cost'          => @cost_field,
        'reverse_cost'  => @reverse_cost_field 
      }
    end

    def cost_query_from
      @edge_table
    end

    def cost_query_where
      ""
    end

    def results_query_select
      {
        'seq'           => :seq,
        'node'          => :id1,
        'edge'          => :id2,
        'cost'          => :cost,
        'reverse_cost'  => :cost
      }
    end

    def results_query_from
      Sequel.function(routing_function, *routing_function_params)
    end

    def results_query_where
      ""
    end

    def cost_query
      select_args = cost_query_select.map {|k,v| Sequel.as(v, k) }
      connection.select(*select_args).from(cost_query_from).where(cost_query_where)
    end

    def results_query
      select_args = results_query_select.map {|k,v| Sequel.as(v, k) }
      connection.select(*select_args).from(*results_query_from).where(results_query_where)
    end

    def routing_function 
      routing_function_definition.keys.first
    end

    def routing_function_params
      routing_function_definition.values.flatten.map {|v| @run_options[v] }.reject {|p| p.nil? }
    end

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

    def import_osm_data(file_name, config_file, options={})
      ::RbRouting::import_osm_data(file_name, @db, @user, config_file, options.merge(@db_options).merge(@import_options))
    end

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