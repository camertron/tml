$:.unshift File.join(File.dirname(__FILE__), 'lib')
require 'tml/version'

Gem::Specification.new do |s|
  s.name     = "tml"
  s.version  = ::Tml::VERSION
  s.authors  = ["Cameron Dutro"]
  s.email    = ["camertron@gmail.com"]
  s.homepage = "http://github.com/camertron"

  s.description = s.summary = "Translation Markup Language"

  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true

  s.require_path = 'lib'
  s.files = Dir["{lib,spec}/**/*", "Gemfile", "History.txt", "README.md", "Rakefile", "tml.gemspec"]
end
