require 'rspec'
$:.push File.expand_path("../lib", __FILE__)
require 'abr_lookup'
require 'webmock/rspec'

module AbrSpecHelpers
  def stub_abn_request(params={})
    stub = stub_request(:get, AbrLookup.abn_lookup_uri.to_s).with(:query => {'searchString' => '12345', 'includeHistoricalDetails' => 'Y', 'authenticationGuid' => AbrLookup.guid}.merge(params))
    yield stub if block_given?
    stub
  end

  def have_requested_abn(params={})
    have_requested(:get, AbrLookup.abn_lookup_uri.to_s).with(:query => {'searchString' => '12345', 'includeHistoricalDetails' => 'Y', 'authenticationGuid' => AbrLookup.guid}.merge(params))
  end

  def fixture(name)
    File.read(File.join('spec/fixtures', name.to_s))
  end
end


RSpec.configure do |c|
  c.include AbrSpecHelpers
end

