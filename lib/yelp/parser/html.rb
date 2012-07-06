require "httparty"
require "nokogiri"

module Yelp::Parser
  class Html < HTTParty::Parser
    SupportedFormats.merge!('text/html' => :html)

    def html
      Nokogiri::HTML(body)
    end
  end
end
