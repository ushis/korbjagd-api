require 'rails_helper'

describe Point do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:latitude) }

    it { is_expected.to validate_numericality_of(:latitude)
                          .is_greater_than(-90.0)
                          .is_less_than(90.0) }

    it { is_expected.to validate_presence_of(:longitude) }

    it { is_expected.to validate_numericality_of(:longitude)
                          .is_greater_than(-180.0)
                          .is_less_than(180.0) }
  end

  describe '#lat' do
    let(:lat) { build(:point).latitude }

    subject { build(:point) }

    it 'is an alias for #latitude' do
      expect { subject.latitude = lat }.to change { subject.lat }.to(lat)
    end
  end

  describe '#lat=' do
    let(:lat) { build(:point).latitude }

    subject { build(:point) }

    it 'is an alias for #latitude=' do
      expect { subject.lat = lat }.to change { subject.latitude }.to(lat)
    end
  end

  describe '#lng' do
    let(:lng) { build(:point).longitude }

    subject { build(:point) }

    it 'is an alias for #longitude' do
      expect { subject.longitude = lng }.to change { subject.lng }.to(lng)
    end
  end

  describe '#lng=' do
    let(:lng) { build(:point).longitude }

    subject { build(:point) }

    it 'is an alias for #lng=' do
      expect { subject.lng = lng }.to change { subject.longitude }.to(lng)
    end
  end

  describe '#to_s' do
    subject { build(:point) }

    it 'is a string including latitude and longitude' do
      expect(subject.to_s).to eq("(#{subject.latitude},#{subject.longitude})")
    end
  end
end
