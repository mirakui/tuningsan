module Autotuner
  module Tunee
    class Stub
      def initialize
        @params = {}
      end

      def update(params)
        @params.merge! params
      end

      def evaluate
        evaluation_function @params[:x]
      end

      private
        def evaluation_function(x)
          80.0-(1/100.0)*((x-71.5)**2)
        end
    end
  end
end
