lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name        = "hobostove"
  s.version     = "0.3.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Oestrich"]
  s.email       = ["eric@oestrich.org"]
  s.summary     = "Command line client for campfire"
  s.description = "Command line client for campfire"
  s.homepage    = "http://github.com/oestrich/hobostove"
  s.license     = "MIT"

  s.required_rubygems_version = ">= 1.3.6"

  # If adding, please consider gemfiles/minimum_dependencies
  s.add_runtime_dependency "faraday", "~> 0.9"
  s.add_runtime_dependency "activesupport", "~> 4.0"
  s.add_runtime_dependency "notify", "~> 0.5"
  s.add_runtime_dependency "gli", "~> 2.11"
  s.add_runtime_dependency "values", "~> 1.5"
  s.add_runtime_dependency "curses", "~> 1.0"

  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "fakefs"

  s.files        = Dir.glob("lib/**/*")
  s.require_path = 'lib'
  s.executables  = ['hobostove']
end

