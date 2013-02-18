require 'pathname'
require 'erb'
require 'tuningsan'
require 'tuningsan/logger'

module Tuningsan
  class Agent
    class TargetConfig
      include Logger
      def initialize(target_config)
        @config = target_config
      end

      def update(hash)
        logger.info "Updating #{dst_path} #{hash.inspect}"
        str = hash.map{|k,v| "<% #{k}=#{v.inspect} %>" }.join
        str += src_path.read
        erb = ERB.new str
        dst_path.open('w+') {|f| f.write erb.result }
      end

      def reload
        cmd = @config[:reload_command]
        logger.info "Reloading: #{cmd}"
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
