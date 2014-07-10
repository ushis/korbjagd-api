require 'rails_helper'

describe Bounds do
  describe '.build' do
    let(:bounds) { Bounds.build(*points) }

    context 'when passing valid points' do
      let(:south) { points.map(&:latitude).min }
      let(:west) { points.map(&:longitude).min }
      let(:north) { points.map(&:latitude).max }
      let(:east) { points.map(&:longitude).max }

      let(:points) do
        (1..10).map { Point.new((rand * 180) - 90, (rand * 360) - 180) }
      end

      it 'has the correct south west latitude' do
        expect(bounds.south_west.latitude).to eq(south)
      end

      it 'has the correct south west longitude' do
        expect(bounds.south_west.longitude).to eq(west)
      end

      it 'has the correct north east latitude' do
        expect(bounds.north_east.latitude).to eq(north)
      end

      it 'has the correct north east longitude' do
        expect(bounds.north_east.longitude).to eq(east)
      end
    end

    context 'when passing nothing' do
      let(:points) { [] }

      it 'has no south west point' do
        expect(bounds.south_west).to be_nil
      end

      it 'has no north east point' do
        expect(bounds.north_east).to be_nil
      end
    end
  end

  describe '#south' do
    let(:south) { Bounds.new(south_west, north_east).south }

    context 'when south_west exists' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { Point.new(543, 123) }

      it 'is the latitude of the south west point' do
        expect(south).to eq(south_west.latitude)
      end
    end

    context 'when south_west is nil' do
      let(:south_west) { nil }
      let(:north_east) { Point.new(543, 123) }

      it 'is nil' do
        expect(south).to be_nil
      end
    end
  end

  describe '#west' do
    let(:west) { Bounds.new(south_west, north_east).west }

    context 'when south_west exists' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { Point.new(543, 123) }

      it 'is the longitude of the south west point' do
        expect(west).to eq(south_west.longitude)
      end
    end

    context 'when south_west is nil' do
      let(:south_west) { nil }
      let(:north_east) { Point.new(543, 123) }

      it 'is nil' do
        expect(west).to be_nil
      end
    end
  end

  describe '#north' do
    let(:north) { Bounds.new(south_west, north_east).north }

    context 'when north_east exists' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { Point.new(543, 123) }

      it 'is the latitude of the north east point' do
        expect(north).to eq(north_east.latitude)
      end
    end

    context 'when north_east is nil' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { nil }

      it 'is nil' do
        expect(north).to be_nil
      end
    end
  end

  describe '#east' do
    let(:east) { Bounds.new(south_west, north_east).east }

    context 'when north_east exists' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { Point.new(543, 123) }

      it 'is the longitude of the north east point' do
        expect(east).to eq(north_east.longitude)
      end
    end

    context 'when north_east is nil' do
      let(:south_west) { Point.new(12, 142) }
      let(:north_east) { nil }

      it 'is nil' do
        expect(east).to be_nil
      end
    end
  end

  describe '#include?' do
    let(:include?) { bounds.include?(point) }

    let(:bounds) { Bounds.new(Point.new(12, 12), Point.new(50, 50)) }

    context 'when the point is inside' do
      let(:point) { Point.new(13, 13) }

      it 'is true' do
        expect(include?).to be true
      end
    end

    context 'when the point is outside' do
      let(:point) { Point.new(11.7, 13) }

      it 'is false' do
        expect(include?).to be false
      end
    end
  end
end
