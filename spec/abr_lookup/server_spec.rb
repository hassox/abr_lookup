require 'spec_helper'

require 'rack'
require 'rack/test'
require 'json'

describe AbrLookup::Server do
  include Rack::Test::Methods

  let(:app) do
    _app_ = lambda{|e| Rack::Response.new('ok').finish }
    Rack::Builder.new do
      use AbrLookup::Server
      run _app_
    end.to_app
  end

  it "should let the request pass through when the path doesn't match" do
    res = get "/not_an_abn_lookup"
    res.body.should == 'ok'
    res.status.should == 200
  end

  it "should match on the path and perform a lookup with the given param" do
    stub_abn_request('searchString' => '1234').to_return(:body => fixture('successful.xml'), :status => 200)
    res = get '/abn_lookup', :abn => '1234'
    res.status.should == 200
    result = JSON.parse(res.body)
    result['abn'].should_not be_empty
  end

  it "should return a 401 if the guid is not correct" do
    stub_abn_request('searchString' => '1234').to_return(:body => fixture('failed_guid.xml'), :status => 200)
    res = get '/abn_lookup', :abn => '1234'
    res.status.should == 401
    result = JSON.parse(res.body)
    result['errors'].should_not be_blank
  end

  it "should return a 404 if the abn is not found" do
    stub_abn_request('searchString' => '1234').to_return(:body => fixture('failed_abn.xml'), :status => 200)
    res = get '/abn_lookup', :abn => '1234'
    res.status.should == 404
    result = JSON.parse(res.body)
    result['errors'].should_not be_blank
  end
end
