module RbRouting

  class PathStep

    attr_reader :name, :node, :edge

    def initialize(result_hash)
      @seq          = result_hash["seq"]
      @node         = result_hash["node"]
      @edge         = result_hash["edge"]
      @cost         = result_hash["cost"]
      @reverse_cost = result_hash["reverse_cost"]
      @name         = result_hash["name"]
      @the_geom     = JSON.parse(result_hash["the_geom"])
    end

    def to_json(*a)
      {
        :seq          => @seq,
        :node         => @node,
        :edge         => @edge,
        :cost         => @cost,
        :reverse_cost => @reverse_cost,
        :name         => @name,
        :the_geom     => @the_geom
      }.to_json(*a)
    end

  end

end