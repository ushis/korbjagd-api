FactoryGirl.define do
  factory :bounds do
    after(:build) do |bounds|
      4.times { bounds.extend(build(:point)) }
    end
  end
end
