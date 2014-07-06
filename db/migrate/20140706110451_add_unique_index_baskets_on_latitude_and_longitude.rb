class AddUniqueIndexBasketsOnLatitudeAndLongitude < ActiveRecord::Migration
  def change
    add_index :baskets, [:latitude, :longitude], unique: true
  end
end
