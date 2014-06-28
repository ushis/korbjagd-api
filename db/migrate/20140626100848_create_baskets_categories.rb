class CreateBasketsCategories < ActiveRecord::Migration
  def change
    create_table :baskets_categories, id: false do |t|
      t.references :basket,   null: false, index: false
      t.references :category, null: false, index: false
      t.index      [:basket_id, :category_id], unique: true
    end
  end
end
