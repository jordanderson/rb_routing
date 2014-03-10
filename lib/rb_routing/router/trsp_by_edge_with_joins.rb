module RbRouting
  module Router

    class TrspByEdgeWithJoins < RbRouting::Router::TrspByEdge

      def results_query_select
        {
          'seq'           => :seq,
          'node'          => :id1,
          'edge'          => :id2,
          'cost'          => :cost,
          'reverse_cost'  => :cost,
          'the_geom'      => Sequel.function(:ST_AsGeoJSON, :the_geom),
          'name'          => :name,
          'bearing'       => Sequel.function(:ST_Azimuth, 
                                Sequel.function(:st_startpoint, :the_geom), 
                                Sequel.function(:ST_PointN, :the_geom, 2)) / 
                                (Sequel.expr(2) * Sequel.function(:pi)) * Sequel.expr(360),
          'bearingrev'    => Sequel.function(:ST_Azimuth,
                                Sequel.function(:st_endpoint, :the_geom),
                                Sequel.function(:ST_PointN, :the_geom, 
                                Sequel.function(:ST_NumPoints, :the_geom) - Sequel.expr(1))) /
                                (Sequel.expr(2) * Sequel.function(:pi)) * Sequel.expr(360)
        }
      end

      def results_query_from
        [Sequel.function(routing_function, *routing_function_params), @edge_table]
      end

      def results_query_where
        {Sequel.qualify(routing_function.to_sym, :id2) => Sequel.qualify(@edge_table, @id_field)}
      end

    end

  end
end
