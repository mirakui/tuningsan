require 'active_support/core_ext'

module Tuningsan
  class Parameters
    def initialize(parameters)
      @params = {}.with_indifferent_access
      parameters.each do |k, v|
        @params[k] = Parameter.new v
      end
    end

    def [](key)
      @params[key]
    end

    def keys
      @params.keys
    end

    class Parameter
      def initialize(parameter)
        @param = parameter
      end

      def min
        @param[:min]
      end

      def max
        @param[:max]
      end

      def type
        @param[:type]
      end
    end
  end
end
