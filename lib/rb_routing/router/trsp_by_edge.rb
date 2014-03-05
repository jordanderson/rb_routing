module RbRouting
  module Router

    class TrspByEdge < RbRouting::Base

      def parameters_spec
        {
          :sql                  => cost_sql,
          :source_edge          => :required,
          :source_pos           => 0.5,
          :target_edge          => :required,
          :target_pos           => 0.5,
          :directed             => false,
          :has_reverse_cost     => false,
          :turn_restriction_sql => :optional
        }
      end

      def routing_query
        {:pgr_trsp => 
          [ :sql, :source_edge, :source_pos, :target_edge, :target_pos, 
            :directed, :has_reverse_cost, :turn_restriction_sql]}
      end

      def cost_sql
        "'SELECT #{@id_field} as id, 
          #{@source_field} as source, 
          #{@target_field} as target, 
          #{@cost_field} as cost,
          #{@reverse_cost_field} as reverse_cost
          FROM #{@edge_table}'"
      end

      def results_sql(options = {})
        "SELECT seq, id1 AS node, id2 AS edge, cost, reverse_cost, name, ST_AsGeoJSON(the_geom) AS the_geom
          FROM #{routing_query_to_sql(options)},
          #{@edge_table}
          WHERE #{@edge_table}.#{@id_field} = id2
          ORDER BY seq;"
      end

    end

  end
end
