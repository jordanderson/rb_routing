module RbRouting
  module Router

    class TrspByVertex < RbRouting::Base

      def routing_function_defaults
        {
          :sql                  => cost_query.sql,
          :source               => :required,
          :target               => :required,
          :directed             => false,
          :has_reverse_cost     => false,
          :turn_restriction_sql => :optional
        }
      end

      def routing_function_definition
        {:pgr_trsp => [:sql, :source, :target, :directed, :has_reverse_cost, :turn_restriction_sql]}
      end

    end

  end
end
