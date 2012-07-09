require "httparty"

module Yelp::Parser
  class DishPhotos < Yelp::Parser::Base

    parser Yelp::Parser::Html

    attr_reader :pages

    def initialize(biz_id)
      super()
      @response = self.class.get("/biz_photos/#{biz_id}")
      check_response
      @pages = Array.new << @response
      fetch_pages
    end

    def photos
      @photos ||= parse_photos
    end

    def search(searh_term)
      result = []
      photos.each do |photo|
        result << photo if photo.has_key?(:caption) && !photo[:caption].scan(searh_term).empty?
      end
      result
    end

    private
      def fetch_pages
        range = @response.parsed_response.css('td.go-to-page a')
        range.each { |r| @pages << self.class.get(r.attributes['href'].value) } unless range.empty?
      end

      def parse_photos
        photos = []
        @pages.each do |page|
          page.css('div#photo-thumbnails div.photo').each do |photo|
            info = { :url => photo.css('div.thumb-wrap img')[0].attributes['src'].value.gsub(/ms\.jpg$/, 'l.jpg')}

            caption = photo.css('div.caption p')

            if caption[0] && !caption[0].css('a').blank?
              info[:profile_name] = caption[0].css('a').text
              info[:profile_url] = caption[0].css('a')[0].attributes['href'].value
            end

            info[:caption] = caption[1].text if caption[1]

            photos << info
          end

        end
        photos.flatten!
        photos
      end

  end
end
