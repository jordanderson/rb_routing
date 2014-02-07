module Rubyrouting

  class Connection

    attr_reader :pg

    def initialize(database, user, options = {})
      @database = database
      @user = user
      @port = options[:port] || "5432"
      @host = options[:host] || "localhost"

      pw = options[:password].blank? ? {} : {:password => options[:password]}
      @pg = PG.connect({:dbname => database, :port => @port, :host => @host, :user => user}.merge(pw))
    end

    def import_osm_data(file_name, config_file, options={})
      options[:host] ||= @pg.host
      options[:port] ||= @pg.port

      Rubyrouting::import_osm_data(file_name, @pg.db, @pg.user, config_file, options)
    end

    def turn_restricted_shortest_path(source, target)
      @pg.exec("SELECT seq, id1 AS node, id2 AS edge, cost
        FROM pgr_trsp(
                'SELECT gid as id, source, target, length as cost FROM ways',
                #{source}, #{target}, false, false
        );")
    
    end

  end

end
