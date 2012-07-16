class AddUnityStorageDigest < ActiveRecord::Migration
  def change
    add_column :yelp_restaurants, :unitystorage_digest, :string
  end
end
