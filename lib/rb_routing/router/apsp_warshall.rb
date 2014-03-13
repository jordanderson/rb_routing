module RbRouting
  module Router

    class ApspWarshall < RbRouting::Base

      def cost_query_select
      {
        'id'            => @id_field,
        'source'        => @source_field,
        'target'        => @target_field,
        'cost'          => @cost_field
      }
    end

      def routing_function_defaults
        {
          :sql              => cost_query.sql,
          :directed         => false,
          :has_reverse_cost => false
        }
      end

      def routing_function_definition
        {:pgr_apspWarshall => [:sql, :directed, :has_reverse_cost]}
      end

    end

  end
end
