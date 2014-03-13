module RbRouting
  module Router

    class BdDijkstra < RbRouting::Base

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
        {:pgr_bdDijkstra => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

    end

  end
end
