module RbRouting

  class Connection

    attr_reader :pg

    def initialize(options = {})
      @database = options[:database]
      @user     = options[:user]
      @port     = options[:port] || "5432"
      @host     = options[:host] || "localhost"

      pw = options[:password].blank? ? {} : {:password => options[:password]}
      @pg = Sequel.postgres({:database => @database, :port => @port, :host => @host, :user => @user}.merge(pw))
    end

  end

end
