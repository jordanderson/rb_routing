module RbRouting
  module Router

    class BdAStar < RbRouting::Router::AStar

      def routing_function_definition
        {:pgr_bdastar => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
