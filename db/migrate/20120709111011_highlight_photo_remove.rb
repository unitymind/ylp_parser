class HighlightPhotoRemove < ActiveRecord::Migration
  def change
    def change
      remove_column :yelp_highlight_dishes, :dish_photo
      remove_column :yelp_highlight_dishes, :profile_photo
    end
  end
end
