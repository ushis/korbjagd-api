require 'rails_helper'

describe Avatar do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe '#image' do
    subject { build(:avatar).image }

    it 'it is a ImageUploader' do
      expect(subject).to be_a(ImageUploader)
    end
  end
end
