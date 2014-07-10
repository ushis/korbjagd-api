FactoryGirl.define do
  factory :basket do
    user
    name { SecureRandom.uuid }
    latitude { build(:point).lat }
    longitude { build(:point).lng }

    trait :with_photo do
      photo
    end
  end
end
