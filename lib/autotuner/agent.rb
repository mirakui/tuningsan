require 'drb/drb'
require 'autotuner/logger'
require 'autotuner/agent/target_config'

module Autotuner
  class Agent
    include Logger
    attr_reader :target_config

    def initialize(config)
      @config = config
      @target_config = TargetConfig.new config[:target_config]
    end

    def start
      #DRb.start_service(uri, self, safe_level: 1)
      DRb.start_service(uri, self)
      logger.info "Listening #{uri} (#{self.class.name})"
      DRb.thread.join
    end

    def uri
      @config['drb_uri']
    end

    def reload
      @target_config.reload
    end

    def update(hash)
      @target_config.update hash
    end
  end
end
