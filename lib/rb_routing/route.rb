module RbRouting

  # r = Route.new
  # r.route_by_edges([1,2,3,4])
  # r.route_by_points([[-73.234, 40.3432], [-73.545, 40.3478], [-73.3784, 40.8983]])

  class Route

    attr_accessor :route

    include ::RbRouting::RouteOptions

    def initialize(options = {})
      set_db_params(options)
      set_routing_params(options)
      @route_class = options[:route_class] || RbRouting::Router::TrspByEdge
    end

    def set_db_params(options = {})
      connect(options)
    end

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

    def path
      @path
    end

    def route_by_edges(edges)
      @route = []

      edges.each_cons(2) do |pair|
        router = @route_class.new(connection.db_options.merge(routing_params))
        router.run(:source_edge => pair[0], :target_edge => pair[1])
        @route << router
      end
      @path = RbRouting::Path.new(@route.map {|r| r.path.steps }.flatten)
    end

  end

end