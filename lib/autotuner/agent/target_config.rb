require 'pathname'
require 'erb'
require 'autotuner'

module Autotuner
  class Agent
    class TargetConfig
      def initialize(target_config)
        @config = target_config
      end

      def update(hash)
        str = hash.map{|k,v| "<% #{k}=#{v.inspect} %>" }.join
        str += src_path.read

        puts '---'
        puts str
        puts '---'

        erb = ERB.new str
        p erb.run
      end

      def reload
        cmd = @config[:reload_command]
        puts "> #{cmd}"
        system cmd, err: :out
      end

      def src_path
        @src_path = Pathname(@config[:src])
      end

      def dst_path
        @dst_path = Pathname(@config[:dst])
      end
    end
  end
end
