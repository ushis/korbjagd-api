require 'rails_helper'

describe AvatarPolicy do
  let(:policy) { AvatarPolicy.new(user, avatar) }

  describe '#show?' do
    subject { policy.show? }

    let(:avatar) { create(:avatar) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#create?' do
    subject { policy.create? }

    context 'as normal user' do
      let(:user) { create(:user) }

      context 'user does own the avatar' do
        let(:avatar) { build(:avatar) }

        it { is_expected.to be false }
      end

      context 'user owns the avatar' do
        let(:avatar) { build(:avatar, user: user) }

        it { is_expected.to be true }
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      let(:avatar) { build(:avatar) }

      it { is_expected.to be true }
    end
  end

  describe '#update?' do
    subject { policy.update? }

    context 'normal user' do
      let(:user) { create(:user) }

      context 'user does own the avatar' do
        let(:avatar) { create(:avatar) }

        it { is_expected.to be false }
      end

      context 'user owns the avatar' do
        let(:avatar) { create(:avatar, user: user) }

        it { is_expected.to be true }
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }

        let(:avatar) { create(:avatar) }

        it { is_expected.to be true }
      end
    end
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    context 'normal user' do
      let(:user) { create(:user) }

      context 'user does own the avatar' do
        let(:avatar) { create(:avatar) }

        it { is_expected.to be false }
      end

      context 'user owns the avatar' do
        let(:avatar) { create(:avatar, user: user) }

        it { is_expected.to be true }
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }

        let(:avatar) { create(:avatar) }

        it { is_expected.to be true }
      end
    end
  end

  describe '#permitted_attributes' do
    subject { policy.permitted_attributes }

    let(:user) { nil }

    let(:avatar) { nil }

    it { is_expected.to match_array([:image]) }
  end

  describe AvatarPolicy::Scope do
    let(:policy_scope) { AvatarPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:user) { create(:user, :admin) }

      let(:scope) { Avatar.all }

      it { is_expected.to eq Avatar.none }
    end
  end
end
