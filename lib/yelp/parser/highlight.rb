require "uri"

module Yelp::Parser
  class Highlight < Yelp::Parser::Base
    attr_reader :data

    parser Yelp::Parser::Xml

    def initialize(data)
      super()
      @data = data
      @response = self.class.get('/biz_details/snapshot_reviews',
                                 :query => {
                                     :biz_id => @data[:biz_id],
                                     :ngram => @data[:dish_name],
                                     :sentence_review_id => @data[:sentence_review_id]
                                 })
      check_response
    end

    def profile
      Yelp::Parser::Profile.new(profile_id)
    end

    private
      def profile_id
        reviews = Nokogiri::HTML(@response.parsed_response.xpath("//reviewSnippets/snippet[@name='reviews']")[0].children[0].inner_text)
        reviews.css('li')[0].css('div.user-passport').css('a')[0].attributes['href'].value.match(/userid=(.+)$/)[1]
      end
  end
end