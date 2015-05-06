$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'datanauts-mailer'
require 'mock_server'
require 'sidekiq/testing'
require 'pry-byebug'
require 'webmock/rspec'
require 'mail'

ENV['RACK_ENV'] = 'test'
Sidekiq::Testing.inline!

def jbody
  JSON.parse last_response.body, symbolize_names: true
end

Mail.defaults do
  delivery_method :test
end

RSpec.configure do |config|
  config.before(:each) do
    Mail::TestMailer.deliveries.clear
  end
end