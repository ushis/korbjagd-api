require 'rails_helper'

describe Photo do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:photos) }
    it { is_expected.to belong_to(:basket).inverse_of(:photo).touch(true) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:basket) }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe '#image' do
    subject { build(:photo).image }

    it 'it is a ImageUploader' do
      expect(subject).to be_a(ImageUploader)
    end
  end
end
