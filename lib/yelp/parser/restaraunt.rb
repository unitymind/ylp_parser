require "httparty"

module Yelp::Parser
  class Restaurant < Yelp::Parser::Base

    parser Yelp::Parser::Html

    attr_reader :biz_id

    def initialize(yelp_uri)
      super()
      @response = self.class.get(yelp_uri)
      check_response
      @biz_id = biz_id
    end

    def highlights
      result = []
      @response.parsed_response.css('div#review_snapshot').css('li.review_summary').each do |highlight|
        data = { :quote => '', :biz_id => @biz_id }
        snippet = highlight.css('div.snippet')
        snippet.children.each do |inline|
          data[:quote] += inline.text if inline.kind_of?(Nokogiri::XML::Text)
          if inline.kind_of?(Nokogiri::XML::Element) && inline.name == 'a'
            ngram = inline.attributes['ngram'].value
            data[:quote] += ngram
            data[:dish_name] = ngram
            data[:sentence_review_id] = inline.attributes['sentence-review-id'].value
          end
          break if inline.kind_of?(Nokogiri::XML::Element) && inline.name == 'span'
        end
        data[:quote].strip!
        data[:quote].gsub!(/^"/, '')
        data[:quote].gsub!(/"$/, '')
        data[:reviews_count] = snippet.css('span.secondary').text.strip.match(/In\s(\d+)\sreview(s?)/)[1].to_i
        result << Yelp::Parser::Highlight.new(data)
      end
      result
    end

    def biz_id
      #puts @response.parsed_response.inspect
      @response.parsed_response.css('div#bizOwner').css('a')[0].attributes['href'].value.match(/biz_id=(.+)$/)[1]
    end

  end
end
