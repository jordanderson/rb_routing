module RbRouting

  module RouteOptions
     def set_routing_params(options = {})
      @id_field           ||= options[:id]              || :gid
      @source_field       ||= options[:source]          || :source
      @target_field       ||= options[:target]          || :target
      @cost_field         ||= options[:cost]            || :length
      @reverse_cost_field ||= options[:reverse_cost]    || :length
      @edge_table         ||= options[:edge_table]      || :ways
    end

    def routing_params
      {   :id => @id_field, 
          :source => @source_field,
          :target => @target_field,
          :cost  => @cost_field,
          :reverse_cost => @reverse_cost_field,
          :edge_table => @edge_table
      }
    end
    
  end

end