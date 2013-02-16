require 'autotuner/logger'

module Autotuner
  module Tunee
    class Command
      include Logger
      SLEEP = 1

      def initialize(agent, plan)
        @agent = agent
        @plan = plan
        @params = {}
      end

      def update(params)
        logger.debug "[command] Updating: #{params.inspect}"
        @params.merge! params
        @agent.update @params
        @agent.reload
      end

      def evaluate
        logger.debug "[command] Executing: #{benchmark_command}"
        sleep SLEEP
        result = `#{benchmark_command}`
        puts "  => #{result}"
        result.to_f
      end

      private
        def benchmark_command
          @benchmark_command ||= @plan[:benchmark_command]
        end
    end
  end
end
