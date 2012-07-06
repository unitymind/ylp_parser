require "httparty"

module Yelp::Parser
  class Base
    include HTTParty

    base_uri 'www.yelp.com'

    attr_reader :response
  end
end
