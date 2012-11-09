require 'hobostove'
require 'fakefs/spec_helpers'

Dir[File.join("./spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include FakeFS::SpecHelpers
end
