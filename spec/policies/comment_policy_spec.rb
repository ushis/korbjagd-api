require 'rails_helper'

describe CommentPolicy do
  let(:policy) { CommentPolicy.new(user, comment) }

  describe '#show?' do
    subject { policy.show? }

    let(:comment) { create(:comment) }

    let(:user) { nil }

    it { is_expected.to be true }
  end

  describe '#create?' do
    subject { policy.create? }

    let(:comment) { build(:comment)  }

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

    let(:comment) { create(:comment) }

    context 'as normal user' do
      context 'user does not own the comment' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'user owns the comment' do
        let(:user) { comment.user }

        it { is_expected.to be true }
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be true }
    end
  end

  describe '#destroy?' do
    subject { policy.update? }

    let(:comment) { create(:comment) }

    context 'as normal user' do
      context 'user does not own the comment' do
        let(:user) { create(:user) }

        it { is_expected.to be false }
      end

      context 'user owns the comment' do
        let(:user) { comment.user }

        it { is_expected.to be true }
      end
    end

    context 'as admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be true }
    end
  end

  describe '#permitted_attributes' do
    subject { policy.permitted_attributes }

    let(:user) { nil }

    let(:comment) { nil }

    it { is_expected.to match_array([:comment]) }
  end

  describe CommentPolicy::Scope do
    let(:policy_scope) { CommentPolicy::Scope.new(user, scope) }

    describe '#resolve' do
      subject { policy_scope.resolve }

      let(:user) { nil }

      let(:scope) { Comment.all }

      it { is_expected.to eq scope }
    end
  end
end
