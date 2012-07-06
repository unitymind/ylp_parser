class CreateYelpRestaurants < ActiveRecord::Migration
  def change
    create_table :yelp_restaurants do |t|
      t.string   :name
      t.string   :ylp_uri
      t.string   :lat
      t.string   :lng
      t.string   :rating
      t.string   :review_count
      t.string   :category
      t.string   :address
      t.string   :phone
      t.string   :web
      t.string   :transit
      t.string   :hours
      t.string   :parking
      t.string   :cc
      t.string   :price
      t.string   :attire
      t.string   :groups
      t.string   :kids
      t.string   :reservation
      t.string   :delivery
      t.string   :takeout
      t.string   :table_service
      t.string   :outdoor_seating
      t.string   :wifi
      t.string   :meal
      t.string   :alcohol
      t.string   :noise
      t.string   :ambience
      t.string   :tv
      t.string   :caters
      t.string   :wheelchair_accessible
      t.string   :fsq_id
      t.string   :fsq_name
      t.string   :fsq_address
      t.string   :fsq_lat
      t.string   :fsq_lng
      t.string   :fsq_checkins_count
      t.string   :fsq_users_count
      t.string   :fsq_tip_count
      t.string   :restaurant_categories
      t.string   :city
      t.boolean  :has_menu,              :default => false
      t.integer  :db_status
      t.integer  :our_network_id
      t.boolean  :menu_copied
      t.timestamps
    end

    add_index :yelp_restaurants, [:city]
    add_index :yelp_restaurants, [:fsq_id]
    add_index :yelp_restaurants, [:has_menu]
    add_index :yelp_restaurants, [:name]
    add_index :yelp_restaurants, [:ylp_uri], :unique => true
  end
end
