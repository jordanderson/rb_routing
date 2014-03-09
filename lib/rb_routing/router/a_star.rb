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
        {:pgr_astar => [:sql, :source, :target, :directed, :has_reverse_cost]}
      end

      def cost_query_select
        {
          'id'            => @id_field,
          'source'        => @source_field,
          'target'        => @target_field,
          'x1'            => @x1_field,
          'x2'            => @x2_field,
          'y1'            => @y1_field,
          'y2'            => @y2_field,
          'cost'          => @cost_field,
          'reverse_cost'  => @reverse_cost_field 
        }
      end

    end

  end
end
