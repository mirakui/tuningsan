require 'drb/drb'
require 'tuningsan/agent'

module Tuningsan
  class Agent
    class AgentFactory
      def initialize(plan)
        @plan = plan
      end

      def create
        Agent.new @plan.agent
      end

      def create_from_remote
        DRbObject.new_with_uri @plan.agent[:drb_uri]
      end

      private
    end
  end
end
