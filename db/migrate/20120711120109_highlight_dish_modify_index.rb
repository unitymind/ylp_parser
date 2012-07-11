class HighlightDishModifyIndex < ActiveRecord::Migration
  def change
    remove_index :yelp_highlight_dishes, [:sentence_review_id]
    add_index :yelp_highlight_dishes, [:restaurant_id, :sentence_review_id], :unique => true
  end
end
