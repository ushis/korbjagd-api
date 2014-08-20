require 'rails_helper'

describe SectorPolicy do
  let(:policy) { SectorPolicy.new(user, sector) }

  describe '#show?' do
    subject { policy.show? }

    let(:sector) { create(:sector) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#create?' do
    subject { policy.create? }

    let(:sector) { build(:sector) }

    let(:user) { create(:user, :admin) }

    it { is_expected.to be false }
  end

  describe '#update?' do
    subject { policy.update? }

    let(:sector) { create(:sector) }

    let(:user) { create(:user, :admin) }

    it { is_expected.to be false }
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    let(:sector) { create(:sector) }

    let(:user) { create(:user, :admin) }

    it { is_expected.to be false }
  end

  describe SectorPolicy::Scope do
    let(:policy_scope) { SectorPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:scope) { Sector.all }

      let(:user) { nil }

      it { is_expected.to eq scope }
    end
  end
end
