class HighlightRemoveYelpUri < ActiveRecord::Migration
  def change
    remove_column :yelp_highlight_dishes, :ylp_uri
  end
end
