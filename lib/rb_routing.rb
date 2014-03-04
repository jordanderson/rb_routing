require 'active_record'
require 'pg'

require "rb_routing/version"
require "rb_routing/connection"
require "rb_routing/base"
require "rb_routing/exceptions"
require "rb_routing/router/trsp"
require "rb_routing/router/dijkstra"
require "rb_routing/router/a_star"

module RbRouting

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
    additional_options << "-clean" if !options[:clean_tables].blank?
    additional_options << "-skipnodes" if !options[:skip_nodes].blank?
    additional_options << "-prefixtables #{options[:prefixtables]}" if !options[:prefixtables].blank?

    puts "Running osm2pgrouting -file #{file_name} -dbname #{database} -user #{user} -conf #{config_file} #{additional_options.join(' ')}"
    value = `osm2pgrouting -file #{file_name} -dbname #{database} -user #{user} -conf #{config_file} #{additional_options.join(' ')}`
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


end
