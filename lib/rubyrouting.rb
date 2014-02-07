require 'pg'
require 'rgeo'
require 'activerecord-postgis-adapter'

require "rubyrouting/version"
require "rubyrouting/connection"

module Rubyrouting

  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgis',
    :database => 'routing',
    :username => 'postgres',
    :password => 'postgres',
    :host     => 'localhost'
  )

  def self.osm2pgrouting_available?
    return true if !`osm2pgrouting`.blank?
    return false
  end

  def self.import_osm_data(file_name, database, user, config_file, options={})
    return false if file_name.blank? or database.blank? or user.blank? or config_file.blank?
    return false if !osm2pgrouting_available?
   
    additional_options = []
    additional_options << "-host #{options[:host]}" if !options[:host].blank?
    additional_options << "-port #{options[:port]}" if !options[:port].blank?
    additional_options << "-passwd #{options[:password]}" if !options[:password].blank?
    additional_options << "-clean" if !options[:clean].blank?
    additional_options << "-skipnodes" if !options[:skipnodes].blank?
    additional_options << "-prefixtables #{options[:prefixtables]}" if !options[:prefixtables].blank?

    puts "Running osm2pgrouting -file #{file_name} -dbname #{database} -user #{user} -conf #{config_file} #{additional_options.join(' ')}"
    value = `osm2pgrouting -file #{file_name} -dbname #{database} -user #{user} -conf #{config_file} #{additional_options.join(' ')}`
    puts value
    return true
  end

  def self.create_topology( edge_table, 
                            tolerance, 
                            the_geom_field = "the_geom", 
                            id_field = "id",
                            source_field = "source",
                            target_field = "target",
                            rows_where = "true"
                          )

  end

  def self.turn_restricted_shortest_path( sql,
                                          source,
                                          target,
                                          directed,
                                          has_reverse_cost,
                                          restrict_sql    
                                        )

    "SELECT seq, id1 AS node, id2 AS edge, cost
        FROM pgr_trsp(
                'SELECT id, source, target, cost FROM edge_table',
                7, 12, false, false
        );"

  end

end
