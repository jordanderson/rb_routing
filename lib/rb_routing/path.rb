module RbRouting

  class Path

    def initialize(path_steps)
      @steps = []

      raise "Error: Can't create path with #{path_steps.class} objects. Please use an Array." if path_steps.class != Array
      path_steps.each do |step|
        if step.class == step_class
          @steps << step
        elsif step.class == Hash
          @steps << step_class.new(step)
        else
          raise "Error: Can't create path with #{step.class} objects."
          return false
        end
      end

      @steps.first.data.each_key do |key|
        self.class.send(:define_method, "all_#{key.to_s.pluralize}".to_sym) { @steps.map {|s| s[key] }}
      end

      @number_of_steps = @steps.size
    end

    def step_class
      RbRouting::PathStep
    end

    def steps
      @steps
    end

    def to_json(*a)
      @steps.to_json(*a)
    end

    def number_of_steps 
      @number_of_steps ||= steps.size
    end

    def total_cost
      steps.map {|s| s[:cost] }.inject {|c, sum| sum + c}
    end

    def to_s
      if !steps.blank? 
        "From edge #{steps.first[:edge]} to edge #{steps.last[:edge]}" 
      else
        super
      end
    end

  end


end