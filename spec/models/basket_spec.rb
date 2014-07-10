require 'rails_helper'

describe Basket do
  describe 'associations' do
    it { is_expected.to belong_to(:user).inverse_of(:baskets).counter_cache(true) }
    it { is_expected.to have_one(:photo).inverse_of(:basket).dependent(:destroy) }
    it { is_expected.to have_many(:comments).inverse_of(:basket).dependent(:destroy).order(:created_at) }
    it { is_expected.to have_many(:commenters).through(:comments).source(:user) }
    it { is_expected.to have_and_belong_to_many(:categories).inverse_of(:baskets) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to ensure_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_numericality_of(:latitude).is_greater_than(-90).is_less_than(90) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_numericality_of(:longitude).is_greater_than(-180).is_less_than(180) }
    it { is_expected.to validate_uniqueness_of(:latitude).scoped_to(:longitude) }
  end

  describe '.inside_bounds' do
    before do
      10.times { create(:basket) }
    end

    let(:inside) { Basket.inside_bounds(bounds) }
    let(:outside) { Basket.where.not(id: inside) }
    let(:bounds) { build(:bounds) }

    it 'includes only baskets inside the given bounds' do
      expect(inside).to all satisfy { |b| bounds.include?(b.to_point) }
    end

    it 'does not miss one' do
      expect(outside).to all satisfy { |b| !bounds.include?(b.to_point) }
    end
  end

  describe '.outside_bounds' do
    before do
      10.times { create(:basket) }
    end

    let(:outside) { Basket.outside_bounds(bounds) }
    let(:inside) { Basket.where.not(id: outside) }
    let(:bounds) { build(:bounds) }

    it 'includes only baskets outside the given bounds' do
      expect(outside).to all satisfy { |b| !bounds.include?(b.to_point) }
    end

    it 'does not miss one' do
      expect(inside).to all satisfy { |b| bounds.include?(b.to_point) }
    end
  end

  describe '#photo!' do
    context 'basket has a photo' do
      subject { basket.photo! }

      let(:basket) { build(:basket, :with_photo) }

      it 'is a photo' do
        expect(subject).to be_a(Photo)
      end

      it 'belongs to the basket' do
        expect(subject.basket).to eq(basket)
      end
    end

    context 'basket has no photo' do
      let(:basket) { build(:basket) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { basket.photo! }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#to_point' do
    subject { basket.to_point }

    let(:basket) { build(:basket) }

    it 'is a point' do
      expect(subject).to be_a(Point)
    end

    it 'has the same latitude as the basket' do
      expect(subject.latitude).to eq(basket.latitude)
    end

    it 'has the same longitude as the basket' do
      expect(subject.longitude).to eq(basket.longitude)
    end
  end
end
