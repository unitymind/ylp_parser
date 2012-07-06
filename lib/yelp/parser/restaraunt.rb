require "httparty"

module Yelp::Parser
  class Restaurant < Yelp::Parser::Base

    parser Yelp::Parser::Html

    def self.parse(yelp_uri, method=:get, options={}, &block)
      self.new(self.send(method.to_sym, yelp_uri, options={}, &block))
    end

    def initialize(response_body)
      @response = response_body
    end

    def highlights
      result = []
      @response.parsed_response.css('div#review_snapshot').css('li.review_summary').each do |highlight|
        data = { :quote => '', :biz_id => biz_id }
        snippet = highlight.css('div.snippet')
        snippet.children.each do |inline|
          data[:quote] += inline.text if inline.kind_of?(Nokogiri::XML::Text)
          if inline.kind_of?(Nokogiri::XML::Element) && inline.name == 'a'
            data[:quote] += inline.attributes['ngram'].value
            data[:dish_name] = inline.attributes['ngram'].value
            data[:sentence_review_id] = inline.attributes['sentence-review-id'].value
          end
          break if inline.kind_of?(Nokogiri::XML::Element) && inline.name == 'span'
        end
        data[:quote].strip!
        data[:quote].gsub!(/^"/, '')
        data[:quote].gsub!(/"$/, '')
        data[:reviews_count] = snippet.css('span.secondary').text.strip.match(/In\s(\d+)\sreviews/)[1].to_i
        result << Yelp::Parser::Highlight.new(data)
      end
      result
    end

    def biz_id
      @response.parsed_response.css('div#bizOwner').css('a')[0].attributes['href'].value.match(/biz_id=(.+)$/)[1]
    end
  end
end
