require 'drb/drb'
require 'autotuner/logger'

module Autotuner
  module Agent
    class Base
      include Logger

      def initialize(uri)
        @uri = uri
      end

      def start
        DRb.start_service(@uri, self, safe_level: 1)
        logger.info "Listening #{@uri} (#{self.class.name})"
        DRb.thread.join
      end
    end
  end
end
