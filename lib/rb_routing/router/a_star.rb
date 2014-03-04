module RbRouting
  module Router

    class AStar < RbRouting::Base

      def set_routing_params(options = {})
        super

        @x1_field ||= options[:x1] || "x1"
        @x2_field ||= options[:x2] || "x2"
        @y1_field ||= options[:y1] || "y1"
        @y2_field ||= options[:y2] || "y2"
      end

      def parameters_spec
        {
          :sql                  => cost_sql,
          :source               => :required,
          :target               => :required,
          :directed             => false,
          :has_reverse_cost     => false
        }
      end

      def routing_query
        {:pgr_astar => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

      def cost_sql
        "'SELECT #{@id_field} as id, 
          #{@source_field} as source, 
          #{@target_field} as target, 
          #{@x1_field} as x1,
          #{@x2_field} as x2,
          #{@y1_field} as y1,
          #{@y2_field} as y2,          
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
