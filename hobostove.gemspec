lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "hobostove"
  s.version     = "0.2.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Oestrich"]
  s.email       = ["eric@oestrich.org"]
  s.summary     = "Command line client for campfire"
  s.description = "Command line client for campfire"
  s.homepage    = "http://github.com/oestrich/hobostove"
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.3.6"

  # If adding, please consider gemfiles/minimum_dependencies
  s.add_runtime_dependency "tinder"
  s.add_runtime_dependency "activesupport"
  s.add_runtime_dependency "notify"
  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "values"
  s.add_runtime_dependency "curses"

  s.add_development_dependency "rspec"
  s.add_development_dependency "fakefs"

  s.files        = Dir.glob("lib/**/*")
  s.require_path = 'lib'
  s.executables  = ['hobostove']
end

