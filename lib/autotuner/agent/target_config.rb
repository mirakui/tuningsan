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
        erb = ERB.new str
        dst_path.open('w+') {|f| f.write erb.result }
      end

      def reload
        cmd = @config[:reload_command]
        puts "> #{cmd}"
        system cmd, err: :out
      end

      def src_path
        @src_path ||= Pathname(@config[:src])
      end

      def dst_path
        @dst_path ||= Pathname(@config[:dst])
      end
    end
  end
end
