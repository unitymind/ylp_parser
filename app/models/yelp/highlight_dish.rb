module Yelp
  class HighlightDish < ActiveRecord::Base
    attr_accessible :sentence_review_id
    belongs_to :restaurant, :class_name => Yelp::Restaurant, :foreign_key => :restaraunt_id
  end
end
