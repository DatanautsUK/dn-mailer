module Datanauts::Mailer
  class Fetcher
    
    def self.client
      @client ||= HTTPClient.new
    end
    
    def fetch(url, params)
      response = self.class.client.get(url, params)
      
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
