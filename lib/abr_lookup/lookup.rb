require 'net/http'
require 'nokogiri'
require 'active_model'

module AbrLookup
  class Lookup
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Naming
    include ActiveModel::Serializers::JSON

    ATTRIBUTES = [:abn, :current, :effective_from, :effective_to, :entity_status, :entity_type, :entity_type_description, :given_name, :family_name, :trading_name, :state_code, :postcode]

    attr_reader :lookup_number
    attr_accessor *ATTRIBUTES

    def initialize(lookup_number)
      @lookup_number = lookup_number.to_s.gsub(/([^\w]|_)/, '')
    end

    def attributes
      attrs = {:lookup_number => lookup_number}
      if errors.present?
        attrs[:errors] = errors.full_messages.join(", ")
      else
        ATTRIBUTES.inject(attrs){|hash, attr| hash[attr] = send(attr) if send(attr).present?; hash }
      end
      attrs
    end

    def as_json(*args)
      attributes.stringify_keys
    end

    def lookup_abn!
      parse_abn_response(perform_abn_lookup)
      self
    end

    private
    def parse_abn_response(response)
      doc = Nokogiri::XML(response)
      doc.css('response').each do |node|
        # Get the returned abn
        self.abn = node.css('ABN identifierValue').text

        # Get the effective dates
        effective_from, effective_to = node.css('entityStatus effectiveFrom').text, node.css('entityStatus effectiveTo').text
        self.effective_from = Date.parse(effective_from) if effective_from.present?
        self.effective_to   = Date.parse(effective_to  ) if effective_to.present?
        
        # Is this abn current
        is_current = node.css('ABN isCurrentIndicator').text
        self.current = !!(is_current && is_current =~ /Y/i)


        self.entity_status           = node.css('entityStatus entityStatusCode' ).text.strip
        self.entity_type             = node.css('entityType entityTypeCode'     ).text.strip
        self.entity_type_description = node.css('entityType entityDescription'  ).text.strip

        self.given_name  = node.css('legalName givenName').text.strip
        self.family_name = node.css('legalName familyName').text.strip

        self.trading_name = node.css('mainTradingName organisationName'      ).text.strip
        self.state_code   = node.css('mainBusinessPhysicalAddress stateCode' ).text.strip
        self.postcode     = node.css('mainBusinessPhysicalAddress postcode'  ).text.strip

        node.css('exception').each do |exception|
          errors.add(exception.css('exceptionCode').text.strip, exception.css('exceptionDescription').text.strip)
        end
      end
    end

    def perform_abn_lookup
      query = "searchString=#{lookup_number}&includeHistoricalDetails=Y&authenticationGuid=#{AbrLookup.guid}"
      uri = AbrLookup.abn_lookup_uri.dup
      uri.query = query
      Net::HTTP.get_response(uri).body
    end
  end
end
