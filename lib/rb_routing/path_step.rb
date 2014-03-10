module RbRouting

  class PathStep

    def initialize(result_hash)
      @result = result_hash
      @result[:the_geom] = JSON.parse(result_hash[:the_geom]) if result_hash[:the_geom].present?
    end

    def to_json(*a)
      @result.to_json(*a)
    end

  end

end