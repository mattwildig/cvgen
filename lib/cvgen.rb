require 'cvgen/parser'
require 'cvgen/converter'

module CVGen

  def self.generate source, opts={}
    root, warnings = Parser.parse(source, opts)
    $stderr.puts warnings if warnings
    output, c_warnings = Converter.convert(root, opts)
    $stderr.puts c_warnings if c_warnings
    output
  end

end
