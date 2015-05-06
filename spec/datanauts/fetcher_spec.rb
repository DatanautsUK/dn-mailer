require 'spec_helper'

module Datanauts::Mailer
  
  describe Fetcher do
    let(:fetcher) { Fetcher.new }
    before do
      stub_request(:get, /example\.com\/with_subject.*/).to_rack(MockServer)
      @response = fetcher.fetch('example.com/with_subject', { name: 'Joe' })
    end
    
    it 'requests to the server' do
      expect(WebMock).to have_requested(:get, "example.com/with_subject").with(query: { name: 'Joe' })
    end
    
    it 'returns the email as json' do
      expect(@response[:subject]).to eql "Hello Joe"
      expect(@response[:html_part]).to eql "<html><body>Test email to Joe</body></html>"
    end

  end

end