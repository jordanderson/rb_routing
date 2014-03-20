module RbRouting
  module Router

    # Find all costs for each pair of nodes in the graph via Floyd-Warshall algorithm (http://docs.pgrouting.org/2.0/en/src/apsp_warshall/doc/index.html#pgr-apsp-warshall)
    # 
    #   @apsp = RbRouting::Router::ApspWarshall.new :host => 'localhost', :database => 'routing', 
    #                                               :user => 'routing', :edge_table => 'ways',
    #                                               :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   @apsp.run
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
