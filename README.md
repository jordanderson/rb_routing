# RbRouting

A ruby wrapper for some pgRouting (http://pgrouting.org/) shortest-path functions

## Preparing a pgRouting database

First make sure you have postgresql with postgis and pgRouting set up. You can use vagrant to get a pgRouting-ready database running quickly and easily:

    $ git clone https://github.com/jordanderson/vagrant-postgis2
    $ cd vagrant-postgis2
    $ git submodule init
    $ git submodule update
    $ vagrant up
    $ psql -h localhost -U postgres -p 6969 -W 

You'll be prompted for the postgres password. It's 'postgres'. The non-standard port is the default for the vagrant image defined above and is handy if you're already running a postgres server on localhost with port 5432. 

Now, we'll create a postgres database called **routing** and add postgis and pgrouting extensions to it:

    psql> CREATE DATABASE routing;
    psql> \c routing
    psql> CREATE EXTENSION postgis;
    psql> CREATE EXTENSION pgrouting; 

## Usage

To get started, the following should download OpenStreetMap (OSM) data for San Francisco, import it into your database using **osm2pgrouting**, and generate a shortest-path query using the turn-restricted shortest path (TRSP) algorithm provided by pgRouting.

    $ brew install osm2pgrouting
    $ curl http://osm-extracted-metros.s3.amazonaws.com/san-francisco.osm.bz2 | bunzip2 > /tmp/sf.osm
    $ irb
    irb> require 'rb_routing'
    irb> trsp = RbRouting::Router::Trsp.new :user => "postgres", :port => 6969, :password => "postgres"
    irb> trsp.import_osm_data "/tmp/sf.osm", "examples/mapconfig.xml"
    irb> result = trsp.run :source => 550, :target => 5463
    irb> result.map {|r| r["name"] }.reject {|r| r.blank? }.join(" -> ")
    => "Davenport Avenue -> Davenport Avenue -> Carson Street -> Adelaide Street -> Huntington Street -> ..."

## To Do

- Edge-to-edge version of TRSP
- Create a result class to simplify output of various formats
- Tests
- Turn-by-turn directions
- Complex examples e.g. user preferences, turn restrictions
