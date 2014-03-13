module RbRouting
  module Router

    class ApspJohnson < RbRouting::Base

      def cost_query_select
      {
        'source'        => @source_field,
        'target'        => @target_field,
        'cost'          => @cost_field
      }
    end

      def routing_function_defaults
        {:sql => cost_query.sql }
      end

      def routing_function_definition
        {:pgr_apspJohnson => [:sql]}
      end

    end

  end
end
