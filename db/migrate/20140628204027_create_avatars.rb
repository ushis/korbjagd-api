class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.references :user,     null: false, index: true
      t.string     :filename, null: false
      t.string     :image,    null: false
      t.timestamps
    end
  end
end
