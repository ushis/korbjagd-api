class BasketSerializer < BasketsSerializer
  attributes :name, :description, :comments_count, :created_at, :updated_at

  has_one :user
  has_one :photo
  has_many :categories
end
