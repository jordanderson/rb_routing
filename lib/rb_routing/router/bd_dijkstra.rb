module RbRouting
  module Router

    # Find the shortest path via Bi-directional Dijkstra algorithm (http://docs.pgrouting.org/2.0/en/src/bd_dijkstra/doc/index.html#bd-dijkstra)
    # 
    #   router = RbRouting::Router::BdDijkstra.new  :host => 'localhost', :database => 'routing', 
    #                                               :user => 'routing', :edge_table => 'ways',
    #                                               :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   router.run :source => 10, :target => 1
    class BdDijkstra < RbRouting::Router::Dijkstra

      def routing_function_definition
        {:pgr_bdDijkstra => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
