module RbRouting

  class Connection

    attr_reader :pg, :db_options, :database, :user, :port, :host, :password

    def initialize(options = {})
      @database     = options[:database]
      @user         = options[:user]
      @port         = options[:port] || "5432"
      @host         = options[:host] || "localhost"
      @table_prefix ||= options[:table_prefix]
      @password     = options[:password]
      
      @db_options   = {:database => @database, :host => @host, :user => @user, 
                        :port => @port, :password => @password, :table_prefix => @table_prefix}

      @password     = options[:password].blank? ? {} : {:password => options[:password]}
      @pg = Sequel.postgres({:database => @database, :port => @port, :host => @host, :user => @user}.merge(@password))
    end

  end

end
