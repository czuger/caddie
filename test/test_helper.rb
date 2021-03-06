# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start do
  add_filter 'dummy'
  add_filter 'factories'
end

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path('../../db/migrate', __FILE__)
require "rails/test_help"

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "test/factories/**/*.rb")].each {|f| require f }

require 'mocha/test_unit'