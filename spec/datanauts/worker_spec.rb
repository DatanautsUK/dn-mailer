require 'spec_helper'

module Datanauts::Mailer
  
  describe Worker do
    
    CONFIG = {'mailer' => {from_domain: "example.com"}}
    
    before do
      stub_request(:get, /example\.com\/.*/).to_rack(MockServer)
    end
    
    it 'works end to end' do
      Worker.perform_async('timmy@timmy.com', 'http://example.com/', {
        name: "Timmy"
      })
      
      expect(Mail::TestMailer.deliveries.length).to eql 1
      
      email = Mail::TestMailer.deliveries.first
      
      expect(email.subject).to eql "Hello Timmy"
      expect(email.html_part.body.to_s).to eql "<html><body>Test email to Timmy</body></html>"
      expect(email.text_part.body.to_s).to eql "Test email to Timmy"
    end

  end

end