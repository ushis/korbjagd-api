require 'rails_helper'

describe PhotoPolicy do
  let(:policy) { PhotoPolicy.new(user, photo) }

  describe '#show?' do
    subject { policy.show? }

    let(:photo) { create(:photo) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#create?' do
    subject { policy.create? }

    context 'as normal user' do
      let(:user) { create(:user) }

      context 'photo is fresh' do
        let(:photo) { build(:photo) }

        it { is_expected.to be true }
      end

      context 'photo is persisted' do
        context 'user does not own the photo' do
          context 'user does not own the photos basket' do
            let(:photo) { create(:photo) }

            it { is_expected.to be false }
          end

          context 'user owns the photos basket' do
            let(:photo) { create(:photo, basket: create(:basket, user: user)) }

            it { is_expected.to be true }
          end
        end

        context 'user owns the photo' do
          let(:photo) { create(:photo, user: user) }

          it { is_expected.to be true }
        end
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      let(:photo) { create(:photo) }

      it { is_expected.to be true }
    end
  end

  describe '#update?' do
    subject { policy.update? }

    context 'as normal user' do
      let(:user) { create(:user) }

      context 'photo is fresh' do
        let(:photo) { build(:photo) }

        it { is_expected.to be true }
      end

      context 'photo is persisted' do
        context 'user does not own the photo' do
          context 'user does not own the photos basket' do
            let(:photo) { create(:photo) }

            it { is_expected.to be false }
          end

          context 'user owns the photos basket' do
            let(:photo) { create(:photo, basket: create(:basket, user: user)) }

            it { is_expected.to be true }
          end
        end

        context 'user owns the photo' do
          let(:photo) { create(:photo, user: user) }

          it { is_expected.to be true }
        end
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      let(:photo) { create(:photo) }

      it { is_expected.to be true }
    end
  end

  describe '#destroy?' do
    subject { policy.destroy? }

    context 'as normal user' do
      let(:user) { create(:user) }

      context 'photo is fresh' do
        let(:photo) { build(:photo) }

        it { is_expected.to be true }
      end

      context 'photo is persisted' do
        context 'user does not own the photo' do
          context 'user does not own the photos basket' do
            let(:photo) { create(:photo) }

            it { is_expected.to be false }
          end

          context 'user owns the photos basket' do
            let(:photo) { create(:photo, basket: create(:basket, user: user)) }

            it { is_expected.to be true }
          end
        end

        context 'user owns the photo' do
          let(:photo) { create(:photo, user: user) }

          it { is_expected.to be true }
        end
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      let(:photo) { create(:photo) }

      it { is_expected.to be true }
    end
  end

  describe '#permitted_attributes' do
    subject { policy.permitted_attributes }

    let(:user) { nil }

    let(:photo) { nil }

    it { is_expected.to match_array([:image]) }
  end

  describe PhotoPolicy::Scope do
    let(:policy_scope) { PhotoPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:user) { create(:user, :admin) }

      let(:scope) { Photo.all }

      it { is_expected.to eq Photo.none }
    end
  end
end
