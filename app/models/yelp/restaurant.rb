module Yelp
  class Restaurant < ActiveRecord::Base
    has_many :highlight_dishes, :class_name => Yelp::HighlightDish, :foreign_key => :restaraunt_id
    has_many :dishes, :class_name => Yelp::Dish, :foreign_key => :ylp_restaurant_id
    has_one :restaurant, :class_name => 'Restaurant', :foreign_key => :yelp_restaurant_id
    scope :highlights_not_parsed, where(:highlight_parsed => false)
    scope :not_in_unitystorage, where('unitystorage_digest is NULL')
  end
end
