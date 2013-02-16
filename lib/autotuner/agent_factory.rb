require 'drb/drb'
require 'active_support/inflector'

module Autotuner
  class AgentFactory
    def initialize(plan)
      @plan = plan
    end

    def create
      class_from_plan.new @plan.agent[:drb_uri]
    end

    def create_from_remote
      DRbObject.new_with_uri @plan.agent[:drb_uri]
    end

    private
      def class_from_plan
        path = "autotuner/agent/#{@plan.agent[:type]}"
        require path
        path.camelize.constantize
      end
  end
end
