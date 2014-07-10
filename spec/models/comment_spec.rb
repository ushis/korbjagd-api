require 'rails_helper'

describe Comment do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:comments) }
    it { is_expected.to belong_to(:basket).inverse_of(:comments).counter_cache(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:basket_id) }
    it { is_expected.to validate_presence_of(:comment) }
  end
end
