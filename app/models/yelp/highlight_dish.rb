module Yelp
  class HighlightDish < ActiveRecord::Base
    belongs_to :restaurant, :class_name => Yelp::Restaurant, :foreign_key => :restaraunt_id
  end
end
