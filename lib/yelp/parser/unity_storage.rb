require "httparty"

module Yelp::Parser
  class UnityStorage
    include HTTParty

    #base_uri 'debug.gaunitystorage.appspot.com'
    #base_uri 'development.gaunitystorage.appspot.com'
    base_uri 'python.gaunitystorage.appspot.com'
    #base_uri 'localhost:8080'
    headers 'Connection' => 'keep-alive'
    default_timeout 60
  end
end
