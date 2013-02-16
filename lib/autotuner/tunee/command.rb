module Autotuner
  module Tunee
    class Command
      SLEEP = 1

      def initialize(agent, plan)
        @agent = agent
        @plan = plan
        @params = {}
      end

      def update(params)
        logger.debug "[command] Updating: #{params.inspect}"
        @params.merge! params
        agent.update @params
      end

      def evaluate
        logger.debug "[command] Executing: #{benchmark_command}"
        sleep SLEEP
        system benchmark_command
      end

      private
        def benchmark_command
          @benchmark_command ||= plan[:benchmark_command]
        end
    end
  end
end
