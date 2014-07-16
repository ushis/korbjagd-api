FactoryGirl.define do
  factory :comment do
    user
    basket
    comment { SecureRandom.hex(32) }
  end
end
