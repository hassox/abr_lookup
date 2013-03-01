require "abr_lookup/version"
require 'yaml'
require 'uri'
require 'erb'

module AbrLookup
  autoload :Lookup, 'abr_lookup/lookup'
  autoload :Server, 'abr_lookup/server'

  def self.abn_lookup_uri
    @abn_lookup_url ||= URI.parse("http://abr.business.gov.au/abrxmlsearchRPC/AbrXmlSearch.asmx/SearchByABNv201205")
  end
  
  def self.asic_lookup_uri
    @asic_lookup_url ||= URI.parse("http://abr.business.gov.au/abrxmlsearchRPC/AbrXmlSearch.asmx/SearchByASICv201205")
  end

  def self.guid
    (configuration['guid'] || configuration[:guid]).to_s
  end

  # The configuration for abn lookup
  # The available options are
  # :guid - the authentication guid http://abr.business.gov.au/
  # :path - the path to match when using middleware
  def self.configuration
    @configuration ||= setup_config
  end

  # Set the configuration for the abn lookup
  # The options that are useful are
  # @see AbrLookup
  def self.configuration=(config)
    @configuration = config
  end

  # The path to find the configuration file
  def self.config_path
    @config_path ||= 'config/abr.yml'
  end

  # Set the path to the configuration file
  def self.config_path=(path)
    @config_path = path
  end

  private

  def self.setup_config
    config = {}
    if File.exists?(config_path)
      config = YAML.load(ERB.new(File.read(config_path)).result)
    end
    config
  end
end
