require 'cvgen'
require 'yaml'

module CVGen
  module Exec

    def self.call
      input = ARGF.read

      if input.start_with? "---\n"
        config, input = input.split /(?<=\.{3}\n)/, 2
        config = YAML.load config
        raise "Config must be a hash" unless config.is_a? Hash
      end
      config ||= {}
      out = CVGen.generate input, config

      $stdout.write out

    end

  end

end