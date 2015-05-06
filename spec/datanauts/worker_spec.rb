require 'spec_helper'
require 'mock_server'

module Datanauts::Mailer

  describe Worker do
    it 'requests to the server' do
      stub_request(:get, /www\.example\.com\/.*/).to_rack(MockServer)
    
      Worker.perform_async('www.example.com', { name: 'Joe' })
    end
  end

end