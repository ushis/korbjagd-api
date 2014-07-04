class RemoveFilenameFromAvatars < ActiveRecord::Migration
  def change
    remove_column :avatars, :filename
  end
end
