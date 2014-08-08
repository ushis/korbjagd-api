require 'rails_helper'

describe Sector do
  describe '.ROWS' do
    subject { Sector::ROWS * Sector::SIZE }

    it { is_expected.to eq(Sector::NORTH_EAST.lat - Sector::SOUTH_WEST.lat) }
  end

  describe '.COLS' do
    subject { Sector::COLS * Sector::SIZE }

    it { is_expected.to eq(Sector::NORTH_EAST.lng - Sector::SOUTH_WEST.lng) }
  end

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
          Sector.find_or_create_by_id(id)
        }.to raise_error(ActiveRecord::RecordInvalid)
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

      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          Sector.find_or_create_by_point(point)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'point out of bounds' do
      let(:point) { Point.new(112.12, 12.132) }

      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          Sector.find_or_create_by_point(point)
        }.to raise_error(ActiveRecord::RecordInvalid)
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

  describe '#south' do
    let(:sector) { build(:sector, id: id) }

    subject { sector.south }

    context 'when id is 0' do
      let(:id) { 0 }

      it { is_expected.to eq(Sector::SOUTH_WEST.lat) }
    end

    context 'when id is maximal' do
      let(:id) { (Sector::ROWS * Sector::COLS) - 1 }

      it { is_expected.to eq(Sector::NORTH_EAST.lat - Sector::SIZE) }
    end

    context 'when id is arbitrary' do
      let(:x) { rand(Sector::COLS) }

      let(:y) { rand(Sector::ROWS - 1) }

      let(:id) { (x * Sector::ROWS) + y }

      let(:other) { build(:sector, id: id + 1) }

      it { is_expected.to eq(other.south - Sector::SIZE) }
    end
  end

  describe '#west' do
    let(:sector) { build(:sector, id: id) }

    subject { sector.west }

    context 'when id is 0' do
      let(:id) { 0 }

      it { is_expected.to eq(Sector::SOUTH_WEST.lng) }
    end

    context 'when id is maximal' do
      let(:id) { (Sector::ROWS * Sector::COLS) - 1 }

      it { is_expected.to eq(Sector::NORTH_EAST.lng - Sector::SIZE) }
    end

    context 'when id is arbitrary' do
      let(:x) { rand(Sector::COLS - 1) }

      let(:y) { rand(Sector::ROWS) }

      let(:id) { (x * Sector::ROWS) + y }

      let(:other) { build(:sector, id: id + Sector::ROWS) }

      it { is_expected.to eq(other.west - Sector::SIZE) }
    end
  end

  describe '#north' do
    let(:sector) { build(:sector) }

    subject { sector.north }

    it { is_expected.to eq(sector.south + Sector::SIZE) }
  end

  describe '#east' do
    let(:sector) { build(:sector) }

    subject { sector.east }

    it { is_expected.to eq(sector.west + Sector::SIZE) }
  end

  describe '#south_west' do
    let(:sector) { build(:sector) }

    subject { sector.south_west }

    it { is_expected.to be_a(Point) }

    it 'has the latitude of the sectors south boundary' do
      expect(subject.latitude).to eq(sector.south)
    end

    it 'has the longitude of the sectors west boundary' do
      expect(subject.longitude).to eq(sector.west)
    end
  end

  describe '#north_east' do
    let(:sector) { build(:sector) }

    subject { sector.north_east }

    it { is_expected.to be_a(Point) }

    it 'has the latitude of the sectors north boundary' do
      expect(subject.latitude).to eq(sector.north)
    end

    it 'has the longitude of the sectors east boundary' do
      expect(subject.longitude).to eq(sector.east)
    end
  end

  describe '#include?' do
    let(:sector) { build(:sector) }

    subject { sector.include?(point) }

    context 'point is inside the sector' do
      let(:point) { Point.new(sector.south + 0.7, sector.west + 1.1) }

      it { is_expected.to be true }
    end

    context 'point is outside the sector' do
      let(:point) { Point.new(sector.south - 0.7, sector.west - 1.1) }

      it { is_expected.to be false }
    end
  end
end
