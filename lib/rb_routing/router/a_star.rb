module RbRouting
  module Router

    # Find the shortest path via A* algorithm (http://docs.pgrouting.org/2.0/en/src/astar/doc/index.html#pgr-astar)
    # 
    #   @a_star = RbRouting::Router::AStar.new  :host => 'localhost', :database => 'routing', 
    #                                           :user => 'routing', :edge_table => 'ways',
    #                                           :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   @a_star.run :source => 10, :target => 1
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
