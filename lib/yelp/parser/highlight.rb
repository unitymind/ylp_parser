require "uri"

module Yelp::Parser
  class Highlight < Yelp::Parser::Base
    attr_reader :data

    parser Yelp::Parser::Xml

    def initialize(data)
      @data = data
      @response = self.class.get('/biz_details/snapshot_reviews',
                                 :query => {
                                     :biz_id => @data[:biz_id],
                                     :ngram => @data[:dish_name],
                                     :sentence_review_id => @data[:sentence_review_id]
                                 })
    end

    def dish_photo

    end

    def profile
      puts @response.parsed_response.reviewSnippets.snippet
    end

  end
end
