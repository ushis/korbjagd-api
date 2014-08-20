require 'rails_helper'

describe CategoryPolicy do
  let(:policy) { CategoryPolicy.new(user, category) }

  describe '#show?' do
    subject { policy.show? }

    let(:user) { create(:user, :admin) }

    let(:category) { create(:category) }

    it { is_expected.to be false }
  end

  describe '#create?' do
    subject { policy.create? }

    let(:user) { create(:user, :admin) }

    let(:category) { build(:category) }

    it { is_expected.to be false }
  end

  describe '#update?' do
    subject { policy.update? }

    let(:user) { create(:user, :admin) }

    let(:category) { create(:category) }

    it { is_expected.to be false }
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    let(:user) { create(:user, :admin) }

    let(:category) { create(:category) }

    it { is_expected.to be false }
  end

  describe CategoryPolicy::Scope do
    let(:policy_scope) { CategoryPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:user) { nil }

      let(:scope) { Category.all }

      it { is_expected.to eq scope }
    end
  end
end
