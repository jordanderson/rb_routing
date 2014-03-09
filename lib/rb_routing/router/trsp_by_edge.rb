module RbRouting
  module Router

    class TrspByEdge < RbRouting::Base

       def routing_function_defaults
        {
          :sql                  => cost_query.sql,
          :source_edge          => :required,
          :source_pos           => 0.5,
          :target_edge          => :required,
          :target_pos           => 0.5,
          :directed             => false,
          :has_reverse_cost     => false,
          :turn_restriction_sql => :optional
        }
      end

      def routing_function_definition
        {:pgr_trsp => 
          [ :sql, :source_edge, :source_pos, :target_edge, :target_pos, 
            :directed, :has_reverse_cost, :turn_restriction_sql]}
      end

    end

  end
end
