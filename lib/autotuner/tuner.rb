require 'autotuner/logger'
require 'autotuner/result'

module Autotuner
  class Tuner
    include Logger

    MAX_DEPTH = 100
    STEP_RANGE = 7
    MIN_STEP_RANGE_RATIO = 0.004

    attr_reader :result

    def initialize(tunee, plan)
      @tunee = tunee
      @plan = plan
      @result = Result.new plan
    end

    def tune(param_name)
      @evaluate_count = 0
      param = @plan.parameters[param_name]
      @start_range = (param.min)..(param.max)
      bench param_name, @start_range
    end

    private
      def bench(param_name, range, depth=0)
        step = ((range.max - range.min) / STEP_RANGE.to_f).ceil
        step_range_ratio = (range.max - range.min).to_f / (@start_range.max - @start_range.min)
        if step <= 0
          logger.info "[#{depth}] finish benchmarking: step=#{step}"
          return
        elsif depth > MAX_DEPTH
          logger.info "[#{depth}] finish benchmarking: depth=#{depth} > #{MAX_DEPTH}"
          return
        elsif step_range_ratio < MIN_STEP_RANGE_RATIO
          logger.info "[#{depth}] finish benchmarking: step_range_ratio=#{step_range_ratio} < #{MIN_STEP_RANGE_RATIO}"
          return
        end

        logger.info "[#{depth}] start benchmarking [#{range}] (step=#{step})"
        max_index, max_value = nil, nil
        range.step(step) do |v|
          actual_value = evaluate param_name, v, depth
          if !max_value || max_value < actual_value
            max_index, max_value = v, actual_value
          end
        end
        logger.info "[#{depth}] max: f(#{param_name}: #{max_index}) = #{max_value}"

        next_min = [(max_index - step), @start_range.min].max
        next_max = [(max_index + step), @start_range.max].min
        next_range = next_min..next_max
        if range == next_range
          logger.info "[#{depth}] finish benchmarking: range converged (#{range})"
          return
        elsif step == 1
          logger.info "[#{depth}] finish benchmarking: step converged (step=#{step})"
          return
        end
        bench param_name, next_range, depth + 1
      end

      def evaluate(param_name, param_value, depth)
        @cache ||= {}
        @evaluate_count += 1
        key = "#{param_name}/#{param_value}"
        if @cache[key]
          logger.debug "[#{depth}] <CACHE> f(#{param_name}: #{param_value}) = #{@cache[key]}"
          @cache[key]
        else
          @cache[key] = begin
            @tunee.update param_name => param_value
            @tunee.evaluate.tap do |value|
              @result.insert param_name, param_value, value
              logger.debug "[#{depth}] #{@evaluate_count} f(#{param_name}: #{param_value}) = #{value}"
            end
          end
        end
      end
  end
end
