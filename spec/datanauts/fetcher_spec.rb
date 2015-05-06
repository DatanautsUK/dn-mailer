require 'spec_helper'

module Datanauts::Mailer
  
  describe Fetcher do
    let(:fetcher) { Fetcher.new }
    before do
      stub_request(:get, /example\.com\/.*/).to_rack(MockServer)
      @response = fetcher.fetch('example.com', { name: 'Joe' })
    end
    
    it 'requests to the server' do
      expect(WebMock).to have_requested(:get, "example.com").with(query: { name: 'Joe' })
    end
    
    it 'returns the email as json' do
      expect(@response[:subject]).to eql "Hello Joe"
      expect(@response[:body][:html]).to eql "<html><body>Test email to Joe</body></html>"
      expect(@response[:body][:text]).to eql "Test email to Joe"
    end

  end

end