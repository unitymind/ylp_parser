class HighlightDishModifyIndex < ActiveRecord::Migration
  def change
    remove_index :yelp_highlight_dishes, [:sentence_review_id]
    add_index :yelp_highlight_dishes, [:restaraunt_id, :sentence_review_id], :name => :index_sentence_review_id_by_restaurant_unique, :unique => true
  end
end
