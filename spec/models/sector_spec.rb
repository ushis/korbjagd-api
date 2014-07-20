require 'rails_helper'

describe Sector do
  describe 'associations' do
    it { is_expected.to have_many(:baskets) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:id).only_integer
                          .is_greater_than_or_equal_to(0)
                          .is_less_than(Sector::ROWS * Sector::COLS) }
  end

  describe '.find_or_create_by_id' do
    context 'invalid id' do
      let(:id) { [-1, Sector::ROWS * Sector::COLS].sample }

      it 'raises an error' do
        expect {
          Sector.find_or_create_by_id(-1)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'valid id' do
      context 'existing sector' do
        let!(:sector) { create(:sector) }

        subject { Sector.find_or_create_by_id(sector.id) }

        it 'is the existing sector' do
          expect(subject).to eq(sector)
        end

        it 'does not create a sector' do
          expect {
            Sector.find_or_create_by_id(sector.id)
          }.to_not change {
            Sector.count
          }
        end
      end

      context 'new sector' do
        let(:id) { rand(Sector::ROWS * Sector::COLS) }

        let(:subject) { Sector.find_or_create_by_id(id) }

        it 'is a sector' do
          expect(subject).to be_a(Sector)
        end

        it 'has the specified id' do
          expect(subject.id).to eq(id)
        end

        it 'has a baskets_count of 0' do
          expect(subject.baskets_count).to eq(0)
        end

        it 'is presisted' do
          expect(subject).to be_persisted
        end
      end
    end
  end

  describe '.find_or_create_by_point' do
    context 'invalid point' do
      let(:point) { Point.new(nil, 12.132) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          Sector.find_or_create_by_point(point)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'point out of bounds' do
      let(:point) { Point.new(112.12, 12.132) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          Sector.find_or_create_by_point(point)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'valid point' do
      let(:point) { Point.new(12.123, 89.321) }

      subject { Sector.find_or_create_by_point(point) }

      context 'sector exists' do
        before { Sector.find_or_create_by_point(point) }

        it 'includes the point' do
          expect(subject.include?(point)).to be true
        end

        it 'is does not create a new sector' do
          expect {
            Sector.find_or_create_by_point(point)
          }.to_not change {
            Sector.count
          }
        end
      end

      context 'sector does not exist' do
        it 'includes the point' do
          expect(subject.include?(point)).to be true
        end

        it 'is persisted' do
          expect(subject).to be_persisted
        end
      end
    end
  end

  describe '#include?' do
    let(:sector) { build(:sector, id: 12) }

    subject { sector.include?(point) }

    context 'point is inside the sector' do
      let(:point) { Point.new(sector.south + 0.7, sector.west + 1.1) }

      it 'is true' do
        expect(subject).to be true
      end
    end

    context 'point is outside the sector' do
      let(:point) { Point.new(70.123, 1643.12) }

      it 'is false' do
        expect(subject).to be false
      end
    end
  end
end
