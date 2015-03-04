require 'cvgen'
require 'yaml'
require 'optparse'

module CVGen
  module Exec

    def self.call
      config = parse_command_line_args

      input = ARGF.read

      merge_options(config, YAML.load_file('config.yml')) if File.exist? 'config.yml'

      if input.start_with? "---\n"
        input.slice!(0..3)
        front, input = input.split /^(?:\.{3}|-{3})\s*$/, 2

        front = YAML.load(front)

        merge_options(config, front)
      end

      out = CVGen.generate input, config

      $stdout.write out

    end

    def self.merge_options(into, from)
        if into[FEATURES_OPTION] && from[FEATURES_OPTION]
          into[FEATURES_OPTION].concat(from.delete(FEATURES_OPTION))
        end

        into.merge!(from)
    end

    def self.parse_command_line_args
      config = {}

      OptionParser.new do |opts|
        opts.on("-e", "--enable FEATURES", Array, "List of features to enable") do |features|
          config[FEATURES_OPTION] = features
        end
      end.parse!

      config
    end

  end
end
