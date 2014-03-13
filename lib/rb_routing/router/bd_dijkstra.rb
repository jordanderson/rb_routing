module RbRouting
  module Router

    class BdDijkstra < RbRouting::Router::Dijkstra

      def routing_function_definition
        {:pgr_bdDijkstra => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
