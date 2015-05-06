require 'sidekiq'

module Datanauts::Mailer
  class Worker
    
    def initialize
      @fetcher = Fetcher.new
      @sender = Sender.new(CONFIG['mailer'] || {})
    end
    
    include Sidekiq::Worker
    
    def perform(to_address, url, params)
      email = @fetcher.fetch(url, params)

      @sender.mail(email.merge(to_address: to_address))
    end
  end
end
