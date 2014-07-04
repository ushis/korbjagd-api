class RemoveDescriptionFromBaskets < ActiveRecord::Migration
  def change
    remove_column :baskets, :description
  end
end
