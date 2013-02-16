require 'logger'

module Autotuner
  module Logger
    def logger
      Autotuner.logger
    end
  end

  module_function
    def logger
      @logger ||= begin
        l = ::Logger.new($stdout)
        l.debug 'Initialized Logger'
        l
      end
    end
end
