module RbRouting

  class Base

    def set_db_params(options = {})
      @db           ||= options[:database]      || "routing"
      @host         ||= options[:host]          || "localhost"
      @user         ||= options[:user] 
      @port         ||= options[:port]          || "5432"
      @password     ||= options[:password]
      @table_prefix ||= options[:table_prefix]
      @db_options    = {:database => @db, :host => @host, :user => @user, 
                        :port => @port, :password => @password, :table_prefix => @table_prefix}
    end

    def set_routing_params(options = {})
      @id_field           ||= options[:id]            || "gid"
      @source_field       ||= options[:source]        || "source"
      @target_field       ||= options[:target]        || "target"
      @cost_field         ||= options[:cost]          || "length"
      @reverse_cost_field ||= options[:reverse_cost]  || "length"
      @edge_table         ||= options[:edge_table]    || "ways"
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

    def build_cost_sql
      
    end

    def cost_sql
      "define in subclass"
    end

    def results_sql
      "define in subclass"
    end

    def explain
      "define in subclass"
    end

    def parameters_spec
      "define in subclass"
    end

    def routing_query
      "define in subclass"
    end

    def routing_function 
      routing_query.keys.first.to_s
    end

    def routing_function_params(params)
      routing_query.values.flatten.map {|v| params[v] }.join(", ")
    end

    def routing_query_to_sql(params={})
      "#{routing_function}(#{routing_function_params(params)})"
    end

    def set_defaults(options = {})
      parameters_spec.each do |key, value|
        options[key] = value if options[key].blank? and ![:optional, :required].include?(value) 
      end

      options
    end

    def validations(options = {})
      errors = []
      parameters_spec.each do |key, value|
        errors << "'#{key}'" if options[key].blank? and value == :required
      end

      raise MissingRoutingParameter, errors.join(", ") unless errors.blank? 
      
      errors
    end

    def pre_import_osm(file_name, config_file, options={})

    end

    def import_osm_data(file_name, config_file, options={})
      pre_import_osm(file_name, config_file, options)
      ::RbRouting::import_osm_data(file_name, @db, @user, config_file, options.merge(@db_options).merge(@import_options))
      post_import_osm(file_name, config_file, options)
    end

    def post_import_osm(file_name, config_file, options={})

    end

    def run(options = {})
      connect
      options = set_defaults(options)
      errors = validations(options)

      puts "Routing options: #{options}"
      connection.exec(results_sql(options)).to_a
    end

  end

end