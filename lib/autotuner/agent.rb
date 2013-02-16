require 'active_support/inflector'

module Autotuner
  module Agent
    module_function
      def from_plan(plan)
        agent_type = plan.agent[:type]
        path = "autotuner/agent/#{agent_type}"
        require path
        path.camelize.constantize.new plan.agent[:drb_uri]
      end
  end
end
