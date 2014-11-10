require 'cvgen'
require 'yaml'

module CVGen
  module Exec

    def self.call
      input = ARGF.read

      config = {}
      config.merge!(YAML.load_file('config.yml')) if File.exist? 'config.yml'

      if input.start_with? "---\n"
        front, input = input.split /(?<=\.{3}\n)/, 2
        config.merge!(YAML.load front)
      end

      out = CVGen.generate input, config

      $stdout.write out

    end

  end

end