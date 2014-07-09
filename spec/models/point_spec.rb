require 'rails_helper'

describe Point do
  describe '.parse_all' do
    let(:points) { Point.parse_all(point_strings) }

    context 'argument is nil' do
      let(:point_strings) { nil }

      it 'is an array' do
        expect(points).to be_a(Array)
      end

      it 'is empty' do
        expect(points).to be_empty
      end
    end

    context 'argument is a string' do
      context 'valid string' do
        let(:point_strings) { coords.join(',') }
        let(:coords) { [51.03123, 13.1233214] }

        it 'has one item' do
          expect(points.length).to eq(1)
        end

        it 'has a point with the correct coordinates' do
          expect(points.first).to eq(Point.new(*coords))
        end
      end

      context 'invalid string' do
        let(:point_strings) { '12.3x,54.2' }

        it 'is empty' do
          expect(points.length).to eq(0)
        end
      end
    end

    context 'argument is an array' do
      let(:point_strings) { coords.map { |c| c.join(',') } }

      context 'all strings are valid' do
        let(:coords) { [[123.123, 43.12], [12.44, 41.55], [76.22, 1.231]] }

        it 'includes all points' do
          points.each_with_index do |point, i|
            expect(point).to eq(Point.new(*coords[i]))
          end
        end
      end

      context 'with invalid strings' do
        let(:valid_coords) { [coords[0], coords[2]] }
        let(:coords) { [[123.123, 43.12], [12.44, 3.12, 41.55], [76.22, 1.2]] }

        it 'has one less item than the passed array' do
          expect(points.length).to eq(valid_coords.length)
        end

        it 'includes the valid points' do
          valid_coords.each do |c|
            expect(points).to include(Point.new(*c))
          end
        end
      end

      context 'with all strings invalid' do
        let(:coords) { [[545.123, nil], ['x', 12.13], [12]] }

        it 'is empty' do
          expect(points).to be_empty
        end
      end
    end

    context 'argument is a hash' do
      let(:point_strings) { {latitude: 12.12, longitude: 423.23} }

      it 'is empty' do
        expect(points).to be_empty
      end
    end
  end

  describe '.from_s' do
    context 'argument is a valid string' do
      let(:point) { Point.from_s(coords.join(',')) }
      let(:coords) { [123.144, 43] }

      it 'is a point with the correct coordinates' do
        expect(point).to eq(Point.new(*coords))
      end
    end

    context 'argument is an invalid string' do
      let(:strings) { ['123.12,1235.12,12.2134', '12x,312', '12,12..'] }

      it 'raises ArgumentError' do
        strings.each do |s|
          expect { Point.from_s(s) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
