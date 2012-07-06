class HighlightBizId < ActiveRecord::Migration
  def change
    add_column :yelp_highlight_dishes, :biz_id, :string
  end
end
