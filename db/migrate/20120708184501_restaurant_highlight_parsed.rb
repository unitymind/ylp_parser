class RestaurantHighlightParsed < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :highlight_parsed, :boolean, :default => false
  end
end
