require 'active_support/core_ext'
require 'yaml'
require 'autotuner/parameters'
require 'autotuner/logger'

module Autotuner
  class Plan
    include Logger

    def initialize(plan)
      @plan = plan.with_indifferent_access
    end

    def parameters
      @parameters ||= Parameters.new(@plan[:parameters])
    end

    def self.load(path)
      Autotuner.logger.debug "Loading plan file: #{path}"
      new YAML.load(open(path).read)
    end
  end
end
