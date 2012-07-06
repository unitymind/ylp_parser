class CreateYelpHighlightDishes < ActiveRecord::Migration
  def change
    create_table :yelp_highlight_dishes do |t|
      t.references :restaraunt
      t.string :quote
      t.integer :reviews_count
      t.string :dish_name
      t.string :dish_photo
      t.string :profile_id
      t.string :profile_name
      t.string :profile_photo
      t.timestamps
    end
  end
end
