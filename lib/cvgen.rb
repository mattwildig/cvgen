require 'cvgen/parser'
require 'cvgen/converter'

require 'erubis'

module CVGen

  FEATURES_OPTION = 'features'.freeze

  def self.generate source, opts={}

    source = Erubis::Eruby.new(source, :bufvar => '@output_buffer').evaluate(ErbContext.new(opts.fetch(FEATURES_OPTION, [])))

    if opts['debug_erb']
      puts source
      exit
    end

    root, warnings = Parser.parse(source, opts)
    $stderr.puts warnings if warnings

    if opts['parse_tree']
      puts root.inspect
      exit
    end

    output, c_warnings = Converter.convert(root, opts)
    $stderr.puts c_warnings if c_warnings
    output
  end

  class ErbContext < BasicObject

    def initialize(features)
      @features = features
      @sections = {}
    end

    def method_missing(method, *args)
      @features.include?(method.to_s)
    end

    def create_section(name)
      $stderr.puts "Warning: Overwriting section \"#{name}\"" if @sections.has_key?(name)

      buf = ''
      @output_buffer, temp = buf, @output_buffer

      yield

      @sections[name] = buf
    ensure
      @output_buffer = temp
    end

    def section(name)
      $stderr.puts "Warning: No section \"#{name}\"" unless @sections.has_key?(name)
      @sections[name]
    end

  end
end
