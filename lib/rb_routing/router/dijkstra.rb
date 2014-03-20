module RbRouting
  module Router

    # Find the shortest path via Dijkstra's algorithm (http://docs.pgrouting.org/2.0/en/src/dijkstra/doc/index.html#pgr-dijkstra)
    # 
    #   router = RbRouting::Router::Dijkstra.new  :host => 'localhost', :database => 'routing', 
    #                                             :user => 'routing', :edge_table => 'ways',
    #                                             :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   router.run :source => 10, :target => 1
    class Dijkstra < RbRouting::Base

      def routing_function_defaults
        {
          :sql                  => cost_query.sql,
          :source               => :required,
          :target               => :required,
          :directed             => false,
          :has_reverse_cost     => false
        }
      end

      def routing_function_definition
        {:pgr_dijkstra => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
