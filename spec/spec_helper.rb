$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'datanauts-mailer'
require 'sidekiq/testing'
require 'pry-byebug'
require 'webmock/rspec'

Sidekiq::Testing.inline!

# RSpec.configure do |config|
#   config.include Datanauts::FormHelper
# end

def jbody
  JSON.parse last_response.body
end