module RbRouting

  class Path

    def initialize(path_steps)
      @steps = []

      raise "Error: Can't create path with #{path_steps.class} objects. Please use an Array." if path_steps.class != Array
      path_steps.each do |step|
        if step.class == RbRouting::PathStep
          @steps << step
        elsif step.class == Hash
          @steps << RbRouting::PathStep.new(step)
        else
          raise "Error: Can't create path with #{step.class} objects. Please use PathSteps or Hashes."
          return false
        end
      end

      @number_of_steps = @steps.size
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

    def to_s
      if !steps.blank? 
        "From edge #{steps.first[:edge]} to edge #{steps.last[:edge]}" 
      else
        super
      end
    end

  end


end