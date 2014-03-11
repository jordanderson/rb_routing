require 'rspec'
require 'rb_routing'
require 'debugger'
require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper.rb')

describe RbRouting, "import_osm_data" do
  it "runs osm2pgouting" do
    osm_file    = "../examples/san-francisco.osm"
    database    = $database
    db_user     = $user
    db_password = $password
    config_file = "../examples/mapconfig.xml"

    RbRouting.import_osm_data(osm_file, database, db_user, config_file, {:password => db_password})
  end
end

describe RbRouting do
  before(:all) do 
    @trsp_v = RbRouting::Router::TrspByVertex.new   :host => $host, :port => $port, :database => $database, 
                                                    :user => $user, :password => $password, :edge_table => :edge_table,
                                                    :id => :id, :cost => :cost, :reverse_cost => :reverse_cost

    @trsp_e = RbRouting::Router::TrspByEdge.new   :host => $host, :port => $port, :database => $database, 
                                                  :user => $user, :password => $password, :edge_table => :edge_table,
                                                  :id => :id, :cost => :cost, :reverse_cost => :reverse_cost

    @dijkstra = RbRouting::Router::Dijkstra.new   :host => $host, :port => $port, :database => $database, 
                                                  :user => $user, :password => $password, :edge_table => :edge_table,
                                                  :id => :id, :cost => :cost, :reverse_cost => :reverse_cost   

    @a_star = RbRouting::Router::Dijkstra.new   :host => $host, :port => $port, :database => $database, 
                                                :user => $user, :password => $password, :edge_table => :edge_table,
                                                :id => :id, :cost => :cost, :reverse_cost => :reverse_cost 

  end
  
  it "raises errors if there are required params missing" do 

    expect { @dijkstra.run(:source => 5) }.to raise_error(RbRouting::MissingRoutingParameter)
    expect { @trsp_e.run(:source => 5, :target => 10) }.to raise_error(RbRouting::MissingRoutingParameter)

  end


  it "finds the shortest path with TRSP by vertex" do
    @trsp_v.run :source => 10, :target => 1
    expect(@trsp_v.path.steps.map {|s| s[:node] }).to eq([10, 7, 2, 1])

    @trsp_v.run :source => 12, :target => 13
    expect(@trsp_v.path.steps.map {|s| s[:node] }).to eq([12, 11, 10, 13])

    @trsp_v.run :source => 12, :target => 13, :directed => true, :has_reverse_cost => true
    expect(@trsp_v.path.steps.map {|s| s[:node] }).to eq([12, 9, 8, 7, 10, 13])
  end

  it "finds the shortest path with TRSP by edge" do
    @trsp_e.run :source_edge => 1, :target_edge => 14
    expect(@trsp_e.path.steps.map {|s| s[:edge] }).to eq([1, 4, 10, 14])

    @trsp_e.run :source_edge => 15, :target_edge => 14
    expect(@trsp_e.path.steps.map {|s| s[:edge] }).to eq([15, 13, 12, 14])

    @trsp_e.run :source_edge => 15, :target_edge => 14, :directed => true, :has_reverse_cost => true
    expect(@trsp_e.path.steps.map {|s| s[:edge] }).to eq([15, 9, 8, 10, 14])
  end

  it "finds the shortest path with Dijkstra" do
    @dijkstra.run :source => 10, :target => 1
    expect(@dijkstra.path.steps.map {|s| s[:node] }).to eq([10, 7, 2, 1])

    @dijkstra.run :source => 12, :target => 13
    expect(@dijkstra.path.steps.map {|s| s[:node] }).to eq([12, 11, 10, 13])

    @dijkstra.run :source => 12, :target => 13, :directed => true, :has_reverse_cost => true
    expect(@dijkstra.path.steps.map {|s| s[:node] }).to eq([12, 9, 8, 7, 10, 13])
  end

  it "finds the shortest path with A*" do
    @a_star.run :source => 10, :target => 1
    expect(@a_star.path.steps.map {|s| s[:node] }).to eq([10, 7, 2, 1])

    @a_star.run :source => 12, :target => 13
    expect(@a_star.path.steps.map {|s| s[:node] }).to eq([12, 11, 10, 13])

    @a_star.run :source => 12, :target => 13, :directed => true, :has_reverse_cost => true
    expect(@a_star.path.steps.map {|s| s[:node] }).to eq([12, 9, 8, 7, 10, 13])
  end

end


