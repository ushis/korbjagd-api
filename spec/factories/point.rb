FactoryGirl.define do
  factory :point do
    latitude { (rand * 180) - 90 }
    longitude { (rand * 360) - 180 }
  end
end
