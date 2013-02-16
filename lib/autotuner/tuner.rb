require 'autotuner/logger'
require 'autotuner/result'

module Autotuner
  class Tuner
    include Logger
    attr_reader :result

    def initialize(tunee, plan)
      @tunee = tunee
      @plan = plan
      @result = Result.new
    end

    def tune(param_name)
      param = @plan.parameters[param_name]
      step = (param.max - param.min) / 10
      bench param_name, param.min, param.max, step
    end

    private
      def bench(param_name, min, max, step, depth=0)
        logger.info "[#{depth}] benchmarking [#{min}..#{max}] (#{step} steps)"
        (min..max).step(step) do |v|
          @tunee.update param_name => v
          actual_value = @tunee.evaluate
          @result.insert param_name, v, actual_value
          logger.debug "[#{depth}] f(#{param_name}: #{v}) = #{actual_value}"
        end
      end
  end
end
