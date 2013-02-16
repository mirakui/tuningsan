require 'autotuner/logger'
require 'autotuner/result'

module Autotuner
  class Tuner
    include Logger

    MAX_DEPTH = 100
    FIRST_STEP_RANGE = 10

    attr_reader :result

    def initialize(tunee, plan)
      @tunee = tunee
      @plan = plan
      @result = Result.new
    end

    def tune(param_name)
      @evaluate_count = 0
      param = @plan.parameters[param_name]
      range = (param.min)..(param.max)
      bench param_name, range
    end

    private
      def bench(param_name, range, depth=0)
        step = ((range.max - range.min) / FIRST_STEP_RANGE.to_f).ceil
        if step <= 0
          logger.info "[#{depth}] finish benchmarking: step=#{step}"
          return
        elsif depth > MAX_DEPTH
          logger.info "[#{depth}] finish benchmarking: depth=#{depth} > #{MAX_DEPTH}"
          return
        end
        max_index, max_value = nil, nil
        logger.info "[#{depth}] start benchmarking [#{range}] (step=#{step})"
        range.step(step) do |v|
          @tunee.update param_name => v
          actual_value = @tunee.evaluate
          if !max_value || max_value < actual_value
            max_index, max_value = v, actual_value
          end
          @result.insert param_name, v, actual_value
          @evaluate_count += 1
          logger.debug "[#{depth}] #{@evaluate_count} f(#{param_name}: #{v}) = #{actual_value}"
        end
        logger.debug "[#{depth}] max: f(#{param_name}: #{max_index}) = #{max_value}"
        next_range = (max_index - step)..(max_index + step)
        if range == next_range
          logger.info "[#{depth}] finish benchmarking: range converged (#{range})"
          return
        elsif step == 1
          logger.info "[#{depth}] finish benchmarking: step converged (step=#{step})"
          return
        end
        bench param_name, next_range, depth + 1
      end
  end
end
