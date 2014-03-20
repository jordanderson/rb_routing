module RbRouting
  module Router

    # Find all costs for each pair of nodes in the graph via Johnson's algorithm (http://docs.pgrouting.org/2.0/en/src/apsp_johnson/doc/index.html#pgr-apsp-johnson)
    # 
    #   @apsp = RbRouting::Router::ApspJohnson.new  :host => 'localhost', :database => 'routing', 
    #                                               :user => 'routing', :edge_table => 'ways',
    #                                               :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   @apsp.run
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
