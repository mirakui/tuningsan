require 'pathname'

module Tuningsan
  module_function
    def base_dir
      @base_dir ||= Pathname('../..').join(__FILE__)
    end
end
