require "httparty"
require "nokogiri"

module Yelp::Parser
  class Xml < HTTParty::Parser
    SupportedFormats.merge!('text/xml' => :xml)

    def xml
      Nokogiri::XML(body)
    end
  end
end
