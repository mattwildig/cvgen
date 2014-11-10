Gem::Specification.new do |s|
  s.name = 'cvgen'
  s.version = '0.0.2'
  s.summary = "Generate CVs in PDF format from Markdown-like source"
  s.description = "Because everybody hates word processors"
  s.author = 'Matt Wildig'
  s.email = 'matt@mattwildig.co.uk'
  s.files = Dir["lib/**/*.rb"] + Dir["bin/*"]
  s.homepage = 'https://github.com/mattwildig/cvgen'
  s.executables << 'cvgen'
  s.add_runtime_dependency 'kramdown', '~> 1.5'
  s.add_runtime_dependency 'prawn', '~> 1.3'
  s.add_runtime_dependency 'prawn-table', '~> 0.2' # Kramdown PDF converter requires this
end
