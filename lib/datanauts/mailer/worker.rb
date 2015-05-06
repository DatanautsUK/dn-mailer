require 'sidekiq'

module Datanauts::Mailer
  class Worker
    
    def initialize
      @fetcher = Fetcher.new
      @sender = Sender.new(CONFIG['mailer'] || {})
    end
    
    include Sidekiq::Worker
    
    def perform(email)
      Hashie.symbolize_keys! email
      
      if fetch_location = email.delete(:fetch)
        email.merge! @fetcher.fetch(fetch_location[:url], fetch_location[:params])
      end

      @sender.mail(email)
    end
  end
end
