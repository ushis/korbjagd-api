class RemoveFilenameFromPhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :filename
  end
end
