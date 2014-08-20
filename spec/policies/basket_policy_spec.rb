require 'rails_helper'

describe BasketPolicy do
  let(:policy) { BasketPolicy.new(user, basket) }

  describe '#show?' do
    subject { policy.show? }

    let(:basket) { create(:basket) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#create?' do
    subject { policy.create? }

    let(:basket) { build(:basket) }

    context 'as anonymous user' do
      let(:user) { nil }

      it { is_expected.to be false }
    end

    context 'as normal user' do
      let(:user) { create(:user) }

      it { is_expected.to be true }
    end
  end

  describe '#update?' do
    subject { policy.update? }

    let(:basket) { create(:basket) }

    context 'as normal user' do
      context 'user does not own the basket' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'nobody owns the basket' do
        before { basket.user = nil }

        let(:user) { create(:user) }

        it { is_expected.to be true }
      end

      context 'user owns the basket' do
        let(:user) { basket.user }

        it { is_expected.to be true }
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be true }
    end
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    let(:basket) { create(:basket) }

    context 'as normal user' do
      context 'user does not own the basket' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'nobody owns the basket' do
        before { basket.user = nil }

        let(:user) { create(:user) }

        it { is_expected.to be true }
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be true }
    end
  end

  describe '#premitted_attributes' do
    subject { policy.permitted_attributes }

    let(:attributes) do
      [:name, :latitude, :longitude, category_ids: []]
    end

    context 'basket is fresh' do
      let(:basket) { build(:basket) }

      let(:user) { create(:user) }

      it { is_expected.to match_array(attributes) }
    end

    context 'basket is persisted' do
      let(:basket) { create(:basket) }

      context 'as normal user' do
        let(:user) { create(:user) }

        it { is_expected.to match_array(attributes - %i(longitude latitude)) }
      end

      context 'as admin' do
        let(:user) { create(:user, :admin) }

        it { is_expected.to match_array(attributes) }
      end
    end
  end

  describe BasketPolicy::Scope do
    let(:policy_scope) { BasketPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:scope) { Basket.all }

      let(:user) { nil }

      it { is_expected.to eq scope }
    end
  end
end
