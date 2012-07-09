require "yelp/parser/html"
require "yelp/parser/xml"
require "yelp/parser/errors"
require "yelp/parser/base"
require "yelp/parser/dish_photos"
require "yelp/parser/highlight"
require "yelp/parser/profile"
require "yelp/parser/restaraunt"

module Yelp
  module Parser
    class << self
      attr_accessor :proxy
    end
  end
end