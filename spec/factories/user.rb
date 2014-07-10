FactoryGirl.define do
  factory :user do
    username { SecureRandom.hex(12)}
    email { "#{SecureRandom.hex(12)}@example.com" }
    password { SecureRandom.uuid }
    password_confirmation { password }
    admin false
    notifications_enabled true

    trait :admin do
      admin true
    end

    trait :not_reachable do
      notifications_enabled false
    end

    trait :with_avatar do
      avatar
    end
  end
end
