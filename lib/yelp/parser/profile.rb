require "httparty"

module Yelp::Parser
  class Profile < Yelp::Parser::Base

    parser Yelp::Parser::Html

    attr_reader :profile_id

    def initialize(profile_id)
      @profile_id = profile_id
      @response = self.class.get('/user_details',
                                       :query => {
                                           :userid => @profile_id
                                       })
    end

    def profile_name
      @response.parsed_response.css('div#user_header').css('h1').text.strip.gsub("'s Profile", '')
    end

    def profile_photo_url
      @response.parsed_response.css('img#main_user_photo_in_about_user_column')[0].attributes['src'].value
    end

  end
end
