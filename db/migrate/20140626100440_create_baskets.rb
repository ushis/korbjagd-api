class CreateBaskets < ActiveRecord::Migration
  def change
    create_table :baskets do |t|
      t.references :user,           null: false, index: true
      t.string     :name,           null: false
      t.float      :latitude,       null: false
      t.float      :longitude,      null: false
      t.text       :description,    null: true
      t.integer    :comments_count, null: false, default: 0
      t.timestamps
    end
  end
end
