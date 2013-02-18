require 'active_support/core_ext'
require 'yaml'
require 'tuningsan/parameters'
require 'tuningsan/logger'

module Tuningsan
  class Plan
    include Logger
    attr_reader :name

    def initialize(plan, name='plan')
      @plan = plan.with_indifferent_access
      @name = name
    end

    def parameters
      @parameters ||= Parameters.new(@plan[:parameters])
    end

    def agent
      @plan[:agent]
    end

    def [](key)
      @plan[key]
    end

    def self.load(path)
      Tuningsan.logger.debug "Loading plan file: #{path}"
      name = path.match(%r!(\w+)\.yml$!)[1]
      new YAML.load(open(path).read), name
    end
  end
end
