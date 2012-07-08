class HighlightIndexes < ActiveRecord::Migration
  def change
    add_index :yelp_highlight_dishes, [:sentence_review_id], :unique => true
  end
end
