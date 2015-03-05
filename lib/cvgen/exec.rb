require 'cvgen'
require 'yaml'
require 'optparse'

module CVGen
  module Exec

    def self.call
      config = parse_command_line_args
      watch = config.delete('watch')

      input_file, output_file = ARGV[0], ARGV[1]

      create_output(input_file, output_file, config)

      if watch
        trap(:INT) { exit }

        require 'listen'
        Listen.to('.', :only => Regexp.new(input_file)) do |modified, added, removed|
          #assume the only possibility is modification of source file
          create_output(input_file, output_file, config)
        end.start

        puts 'Listening for changes, Ctrl-C to exit'
        sleep
      end
    end

    def self.create_output(input_file, output_file, config)
      input = File.read(input_file)
      merge_options(config, YAML.load_file('config.yml')) if File.exist? 'config.yml'

      if input.start_with? "---\n"
        input.slice!(0..3)
        front, input = input.split /^(?:\.{3}|-{3})\s*$/, 2

        front = YAML.load(front)

        merge_options(config, front)
      end

      pdf_data = CVGen.generate input, config
      IO.binwrite(output_file, pdf_data)
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

        opts.on("-w", "--watch", "Watch for changes and automatically regenerate pdf") do
          config['watch'] = true
        end
      end.parse!

      config
    end

  end
end
