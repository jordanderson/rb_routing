require 'rspec'
require 'rubyrouting'

describe Rubyrouting, "import_osm_data" do
  it "runs osm2pgouting" do
    osm_file    = "../examples/san-francisco.osm"
    database    = "routing"
    db_user     = "postgres"
    db_password = "postgres"
    config_file = "../examples/mapconfig.xml"

    Rubyrouting.import_osm_data(osm_file, database, db_user, config_file, {:password => db_password})
  end
end

=begin

  Rubyrouting.connection(:db => "blah", :user => "postgres", :port => 5432)
  Rubyrouting.import_osm_data(osm_file, config_file, options)
  Rubyrouting.create_topology(table, tolerance, options)
  Rubyrouting.turn_restricted_shortest_path_by_nodes(start_node, end_node, options)
  Rubyrouting.turn_restricted_shortest_path_by_edges(start_edge, end_edge, options)


  bounding box: the_geom && setsrid(
                      'BOX3D(#{ll_point.lon-0.01}
                             #{ll_point.lat-0.01}, 
                             #{ur_point.lon+0.01} 
                             #{ur_point.lat+0.01})'::box3d, 4326) 

  class Rubyrouting::Base

    def initialize(options={})
      @id         = options[:id]
      @source     = options[:source]
      @target     = options[:target]
      @cost       = options[:cost]
      @edge_table = options[:edge_table]
    end

    def cost_sql
      "define in subclass"
    end

    def results_sql
      "define in subclass"
    end

    def run(start, end, options = {})
      "define in subclass"
    end

  end

  class Rubyrouting::Trsp < Rubyrouting::Base

    def sql_spec
      "SELECT :id, :source, :target, :cost FROM :edge_table"
    end

    def cost_sql
      sql_spec.gsub(/:{1}(\w+)/) do |match|
        instance_variable_get("@#{$1}")
      end
    end

    def results_sql
      "SELECT seq, id1 AS node, id2 AS edge, cost
        FROM pgr_trsp(#{cost_sql}, 7, 12, false, false);"
    end

    def run(start, end, options = {})
      conn.exec(results_sql)
    end

  end

  class MyFancyUserRouting < Rubyrouting::Trsp

    def initialize(options = {})
      super
      @user = options[:user]
    end

    def cost_sql
      "SELECT id, source, target, edge_table.cost * COALESCE(user_edge_costs.multiplier, 1) as cost
        FROM edge_table
        LEFT JOIN user_edge_costs 
        ON edge_table.gid = user_edge_costs.edge_id 
        AND user_edge_costs.user_id = #{@user}"
    end

    def results_sql
      "SELECT seq, id1 AS node, id2 AS edge, cost, name
        FROM pgr_trsp(#{actual_sql}, 7, 12, false, false),
        edge_table
        WHERE edge_table.gid = edge
        ORDER BY seq;"
    end

  end

  def self.turn_restricted_shortest_path_by_nodes(start_node, end_node, options={})

    "SELECT seq, id1 AS node, id2 AS edge, cost
        FROM pgr_trsp(
                'SELECT id, source, target, cost FROM edge_table',
                7, 12, false, false
        );"

  end

=end 