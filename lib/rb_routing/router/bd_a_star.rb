module RbRouting
  module Router

    # Find the shortest path via Bi-directional A* algorithm (http://docs.pgrouting.org/2.0/en/src/bd_astar/doc/index.html#bd-astar)
    # 
    #   @router = RbRouting::Router::BdAStar.new  :host => 'localhost', :database => 'routing', 
    #                                             :user => 'routing', :edge_table => 'ways',
    #                                             :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   @router.run :source => 10, :target => 1
    class BdAStar < RbRouting::Router::AStar

      def routing_function_definition
        {:pgr_bdastar => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
