module RbRouting
  module Router

    # Find the shortest path from vertex to vertex via Turn-restricted shortest path algorithm 
    # (http://docs.pgrouting.org/2.0/en/src/trsp/doc/index.html#trsp)
    # 
    #   router = RbRouting::Router::TrspByVertex.new  :host => 'localhost', :database => 'routing', 
    #                                                 :user => 'routing', :edge_table => 'ways',
    #                                                 :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 
    #
    #   router.run :source => 10, :target => 1
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
