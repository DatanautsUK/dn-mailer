require 'spec_helper'

module Datanauts::Mailer
  
  describe Sender do
    include Mail::Matchers
    
    before do
      @sender = Sender.new(from_domain: "example.com")
    end
    
    it 'sends email' do
      @sender.mail({
        to_address: 'foo@bar.com',
        subject: 'thesubject',
        body: {
          text: "text body",
          html: "<html><body>html body</body></html>"
        }
      })
      
      expect(Mail::TestMailer.deliveries.length).to eql 1
    end
    
    context 'in local env' do
      before(:all) { ENV['RACK_ENV'] = 'local' }
      after(:all)  { ENV['RACK_ENV'] = 'test'  }
      
      it 'doesnt send email' do
        @sender.mail({
          to_address: 'foo@bar.com',
          subject: 'thesubject',
          body: {
            text: "text body",
            html: "<html><body>html body</body></html>"
          }
        })

        expect(Mail::TestMailer.deliveries.length).to eql 0
      end
    end

  end

end