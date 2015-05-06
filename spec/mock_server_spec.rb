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
    
    expect(jbody[:html_part]).to eql '<html><body>Test email to Joe</body></html>'
  end
end