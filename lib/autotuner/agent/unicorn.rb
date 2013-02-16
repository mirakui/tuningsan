require 'autotuner/agent/base'

module Autotuner
  module Agent
    class Unicorn < Base
      def initialize(plan)
        super
      end

      def hello
        Time.now
      end
    end
  end
end
