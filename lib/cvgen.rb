require 'cvgen/parser'
require 'cvgen/converter'

require 'erubis'

module CVGen

  FEATURES_OPTION = 'features'.freeze

  def self.generate source, opts={}

    source = Erubis::Eruby.new(source).evaluate(ErbContext.new(opts.fetch(FEATURES_OPTION, [])))

    root, warnings = Parser.parse(source, opts)
    $stderr.puts warnings if warnings
    output, c_warnings = Converter.convert(root, opts)
    $stderr.puts c_warnings if c_warnings
    output
  end

  class ErbContext < BasicObject

    def initialize(features)
      @features = features
    end

    def method_missing(method, *args)
      @features.include?(method.to_s)
    end

  end
end
