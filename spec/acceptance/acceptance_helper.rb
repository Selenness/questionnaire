require 'rails_helper'

RSpec.configure do |config|
  Capybara.server = :puma
  config.use_transactional_fixtures = true

    # Capybara.javascript_driver = :webkit

  config.include AcceptanceHelper, type: :feature
  # config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    OmniAuth.config.test_mode = true
  end

  config.include OmniauthMacros, type: :feature
end