FactoryGirl.define do
  factory :sector do
    id { rand(Sector::ROWS * Sector::COLS) }
  end
end
