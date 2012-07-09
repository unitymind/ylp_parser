require "httparty"

module Yelp::Parser
  class Base
    include HTTParty

    base_uri 'www.yelp.com'

    attr_reader :response

    def initialize
      set_proxy(Yelp::Parser.proxy) if Yelp::Parser.proxy
    end

    private
      def check_response
        if @response.response.kind_of?(Net::HTTPClientError)
          raise Yelp::Parser::Errors::HttpError.new(@response.response.class)
        end
      end

      def set_proxy(proxy_string)
        splitted = proxy_string.split(':')
        self.class.http_proxy(splitted[0], splitted[1].to_i)
      end
  end
end
