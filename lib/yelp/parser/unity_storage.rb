require "httparty"

module Yelp::Parser
  class UnityStorage
    include HTTParty

    #base_uri '1.gaunitystorage.appspot.com'
    base_uri 'localhost:8080'
    headers 'Connection' => 'keep-alive'
  end
end
