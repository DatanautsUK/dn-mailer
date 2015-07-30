require 'sidekiq'

module Datanauts::Mailer
  class Worker
    include Sidekiq::Worker

    sidekiq_options :queue => :mailer

    def setup(config)
      @fetcher = Fetcher.new
      @sender = Sender.new(config)
    end


    # ==================
    # = email example
    # = {
    # =  to_address: 'marek@datanauts.co.uk',
    # =  subject: "test",
    # =  html_part: '<html><brody>Hello</body></html>,
    # =  text_part: 'Hello'
    # = }
    # ==================
    def perform(email)
      Hashie.symbolize_keys! email
      setup(from_domain: email[:from_domain])

      if fetch_location = email.delete(:fetch)
        email.merge! @fetcher.fetch(fetch_location[:url], fetch_location[:params])
      end

      @sender.mail(email)
    end
  end
end
