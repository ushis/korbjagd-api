class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.references :basket,   null: false, index: true
      t.string     :filename, null: false
      t.string     :image,    null: false
      t.timestamps
    end
  end
end
