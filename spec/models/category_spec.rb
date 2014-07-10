require 'rails_helper'

describe Category do
  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:baskets).inverse_of(:categories) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
