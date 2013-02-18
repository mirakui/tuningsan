require 'logger'

module Tuningsan
  module Logger
    def logger
      Tuningsan.logger
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
