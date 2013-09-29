require 'capybara/cucumber'
require 'capybara/rspec'

ENV['RACK_ENV'] = 'test'
 
Capybara.default_wait_time = 5
Capybara.default_driver = :selenium
Capybara.javascript_driver = :webkit

