module Autotuner
  class Agent
    class TargetConfig
      def initialize(target_config)
        @config = target_config
      end

      def update(hash)

      end

      def reload
        cmd = @config[:reload_command]
        puts "> #{cmd}"
        system cmd, err: :out
        puts 'OK'
      end
    end
  end
end
