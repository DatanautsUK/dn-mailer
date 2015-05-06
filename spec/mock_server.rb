require 'sinatra'

class MockServer < Sinatra::Base
  get '/' do  
    {
      html_part: "<html><body>Test email to #{params[:name]}</body></html>"
    }.to_json
    
  end
  
  get '/with_subject' do
    {
      html_part: "<html><body>Test email to #{params[:name]}</body></html>",
      subject: "Hello #{params[:name]}"
    }.to_json
    
  end
end
