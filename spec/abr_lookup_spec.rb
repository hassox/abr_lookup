require 'spec_helper'

describe AbrLookup do
  describe "Config" do
    after do
      AbrLookup.config_path   = nil
      AbrLookup.configuration = nil
    end

    it "should have the abn_lookup_uri" do
      AbrLookup.abn_lookup_uri.to_s.should == 'http://abr.business.gov.au/ABRXMLSearchRPC/ABRXMLSearch.asmx/ABRSearchByABN'
    end

    it "should load the configuration from the default path" do
      AbrLookup.configuration['guid'].should == 123
    end

    it "should load the configuration from an alternative path" do
      AbrLookup.config_path = 'config/alt.yml'
      AbrLookup.configuration['guid'].should == 'alternative'
    end

    it "should load the configuration when set manually" do
      AbrLookup.configuration = {'guid' => 'foo'}
      AbrLookup.configuration.should == {'guid' => 'foo'}
    end
  end
end
