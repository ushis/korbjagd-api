require 'rails_helper'

describe UserPolicy do
  let(:policy) { UserPolicy.new(user, record) }

  describe '#show?' do
    subject { policy.show? }

    let(:record) { create(:user) }

    context 'user is not the record' do
      context 'user is a normal user' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'user is an admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to be true }
      end
    end

    context 'user is the record' do
      let(:user) { record }

      it { is_expected.to be true }
    end
  end

  describe '#create?' do
    subject { policy.create? }

    let(:record) { build(:user) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#update?' do
    subject { policy.update? }

    let(:record) { create(:user) }

    context 'user is not the record' do
      context 'user is a normal user' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'user is an admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to be true }
      end
    end

    context 'user is the record' do
      let(:user) { record }

      it { is_expected.to be true }
    end
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    let(:record) { create(:user) }

    context 'user is not the record' do
      context 'user is a normal user' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'user is an admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to be true }
      end
    end

    context 'user is the record' do
      let(:user) { record }

      it { is_expected.to be true }
    end
  end

  describe '#premitted_attributes' do
    subject { policy.permitted_attributes }

    let(:attributes) do
      %i(username email notifications_enabled password password_confirmation)
    end

    context 'record is fresh' do
      let(:record) { build(:user) }

      let(:user) { nil }

      it { is_expected.to match_array(attributes) }
    end

    context 'record is persisted' do
      let(:record) { create(:user) }

      context 'as normal user' do
        let(:user) { create(:user) }

        it { is_expected.to match_array(attributes - [:username]) }
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to match_array(attributes) }
      end
    end
  end

  describe UserPolicy::Scope do
    let(:policy_scope) { UserPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:scope) { User.all }

      context 'as normal user' do
        let(:user) { create(:user) }

        it { is_expected.to eq User.none }
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to eq scope }
      end
    end
  end
end
