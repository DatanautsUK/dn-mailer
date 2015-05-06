require 'sinatra'

class MockServer < Sinatra::Base
  get '/' do  
    {
      body: {
       text: "Test email to #{params[:name]}",
       html: "<html><body>Test email to #{params[:name]}</body></html>"
      },
      subject: "Hello #{params[:name]}"
    }.to_json
    
  end
end
