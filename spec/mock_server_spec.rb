require 'spec_helper'
require 'rack/test'
require 'mock_server'

describe MockServer do
  include Rack::Test::Methods
  
  def app
    MockServer.new
  end
  
  it 'returns OK' do
    get '/'
    
    expect(last_response.status).to eql 200
  end
  
  it 'returns json' do
    get '/', name: 'Joe'
    
    expect(jbody['subject']).to eql 'Hello Joe'
    expect(jbody['body']['html']).to eql '<html><body>Test email to Joe</body></html>'
    expect(jbody['body']['text']).to eql 'Test email to Joe'
  end
end