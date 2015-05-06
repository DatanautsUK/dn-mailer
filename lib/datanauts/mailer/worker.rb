require 'sidekiq'

module Datanauts::Mailer
  class Worker
    include Sidekiq::Worker
    
    def self.client
      @client ||= HTTPClient.new
    end
  
    
    def perform(url, params)
      email = self.class.client.get url, params
    end
  end
end