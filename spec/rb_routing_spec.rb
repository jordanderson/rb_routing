require 'rspec'
require 'rb_routing'

describe RbRouting, "import_osm_data" do
  it "runs osm2pgouting" do
    osm_file    = "../examples/san-francisco.osm"
    database    = "routing"
    db_user     = "postgres"
    db_password = "postgres"
    config_file = "../examples/mapconfig.xml"

    RbRouting.import_osm_data(osm_file, database, db_user, config_file, {:password => db_password})
  end
end
