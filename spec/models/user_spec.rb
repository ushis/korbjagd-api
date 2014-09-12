require 'rails_helper'

describe User do
  it { is_expected.to have_secure_password }

  describe 'associations' do
    it { is_expected.to have_one(:avatar).inverse_of(:user).dependent(:destroy) }
    it { is_expected.to have_many(:baskets).inverse_of(:user) }
    it { is_expected.to have_many(:comments).inverse_of(:user).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to ensure_length_of(:username).is_at_most(255) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to ensure_length_of(:email).is_at_most(255) }

    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_confirmation_of(:password) }

    describe 'uniqueness validations' do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:username) }
      it { is_expected.to validate_uniqueness_of(:email) }
    end

    describe 'password_confirmation' do
      context 'password is present' do
        subject { User.new(password: 'secret') }

        it { is_expected.to validate_presence_of(:password_confirmation) }
      end

      context 'password is not present' do
        subject { User.new(password: nil) }

        it { is_expected.to_not validate_presence_of(:password_confirmation) }
      end
    end
  end

  describe 'before_validation' do
    describe 'normalize_username' do
      subject { User.new(username: username) }

      context 'when username is already normalized' do
        let(:username) { 'harry123' }

        it 'does not change anything' do
          expect { subject.valid? }.to_not change { subject.username }
        end
      end

      context 'when username includes caps and spaces' do
        let(:username) { '  hArrY123 ' }

        it 'downcases and strips the username' do
          expect {
            subject.valid?
          }.to change {
            subject.username
          }.from(username).to(username.strip.downcase)
        end
      end
    end

    describe 'normalize_email' do
      subject { User.new(email: email) }

      context 'when email is already normalized' do
        let(:email) { 'haRRay123@example.com' }

        it 'does not change anything' do
          expect { subject.valid? }.to_not change { subject.email }
        end
      end

      context 'when username includes spaces' do
        let(:email) { ' haRR123@example.com  ' }

        it 'strips the email' do
          expect {
            subject.valid?
          }.to change {
            subject.email
          }.from(email).to(email.strip)
        end
      end

    end
  end

  describe '.admins' do
    before do
      5.times { create(:user) }
      3.times { create(:user, :admin) }
    end

    subject { User.admins.to_a }

    it 'includes 3 users' do
      expect(subject.length).to eq(3)
    end

    it { is_expected.to all(be_admin) }
  end

  describe '.reachable' do
    before do
      5.times { create(:user) }
      3.times { create(:user, :not_reachable) }
    end

    subject { User.reachable.to_a }

    it 'includes 5 users' do
      expect(subject.length).to eq(5)
    end

    it { is_expected.to all(be_reachable) }
  end

  describe '.exclude' do
    before do
      5.times { create(:user) }
    end

    subject { User.exclude(*exclude) }

    context 'with no arguments' do
      let(:exclude) { [] }

      it 'includes all users' do
        expect(subject).to match_array(User.all)
      end
    end

    context 'with 2 users excluded' do
      let(:exclude) { User.limit(2) }

      it 'has 3 users' do
        expect(subject.length).to eq(3)
      end

      it 'does not include the excluded users' do
        expect(subject).to_not include(*exclude)
      end
    end

    context 'with 2 valid ids passed and nil' do
      let(:exclude) { User.limit(2).map(&:id) << nil }

      it 'has 3 users' do
        expect(subject.length).to eq(3)
      end

      it 'does not include the excluded users' do
        expect(subject.map(&:id)).to_not include(exclude)
      end
    end
  end

  describe '.find_by_auth_token' do
    before do
      5.times { create(:user) }
    end

    subject { User.find_by_auth_token(token) }

    let(:user) { User.first }

    context 'given a valid token' do
      let(:token) { AuthToken.for(user).to_s }

      it 'is the correct user' do
        expect(subject).to eq(user)
      end
    end

    context 'given an invalid token' do
      let(:token) { "#{AuthToken.for(user).to_s}x" }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given an expired token' do
      let(:token) do
        AuthToken.new(user.id, 3.days.ago.to_i, AuthToken.scope).to_s
      end

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given a token with invalid scope' do
      let(:token) { PasswordResetToken.for(user).to_s }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.find_by_password_reset_token' do
    before do
      5.times { create(:user) }
    end

    subject { User.find_by_password_reset_token(token) }

    let(:user) { User.first }

    context 'given a valid token' do
      let(:token) { PasswordResetToken.for(user).to_s }

      it 'is the correct user' do
        expect(subject).to eq(user)
      end
    end

    context 'given an invalid token' do
      let(:token) { "#{PasswordResetToken.for(user).to_s}x" }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given an expired token' do
      let(:token) do
        PasswordResetToken.new(user.id, 1.day.ago.to_i, PasswordResetToken.scope).to_s
      end

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given a token with invalid scope' do
      let(:token) { AuthToken.for(user).to_s }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '.find_by_delete_token' do
    before do
      5.times { create(:user) }
    end

    subject { User.find_by_delete_token(token) }

    let(:user) { User.first }

    context 'given a valid token' do
      let(:token) { ProfileDeleteToken.for(user).to_s }

      it 'is the correct user' do
        expect(subject).to eq(user)
      end
    end

    context 'given an invalid token' do
      let(:token) { "#{ProfileDeleteToken.for(user).to_s}x" }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given an expired token' do
      let(:token) do
        ProfileDeleteToken.new(user.id, 1.day.ago.to_i, ProfileDeleteToken.scope).to_s
      end

      it 'is nil' do
        expect(subject).to be_nil
      end
    end

    context 'given a token with invalid scope' do
      let(:token) { AuthToken.for(user).to_s }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe 'find_by_email_or_username' do
    before do
      5.times { create(:user) }
    end

    subject { User.find_by_email_or_username(email_or_username) }

    let(:user) { User.last }

    context 'given a valid username' do
      let(:email_or_username) { user.username }

      it 'is the correct user' do
        expect(subject).to eq(user)
      end
    end

    context 'given a valid email' do
      let(:email_or_username) { user.email }

      it 'is the correct user' do
        expect(subject).to eq(user)
      end
    end

    context 'given incorrect username or email' do
      let(:email_or_username) { 'incorrect-email-or-username' }

      it 'is nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#auth_token' do
    subject { user.auth_token }

    let(:token) { AuthToken.for(user).to_s }
    let(:user) { create(:user) }

    it 'is a short cut for AuthToken.for(user).to_s' do
      expect(subject).to eq(token)
    end
  end

  describe '#password_reset_token' do
    subject { user.password_reset_token }

    let(:token) { PasswordResetToken.for(user).to_s }
    let(:user) { create(:user) }

    it 'is a short cut for PasswordResetToken.for(user).to_s' do
      expect(subject).to eq(token)
    end
  end

  describe '#delete_token' do
    subject { user.delete_token }

    let(:token) { ProfileDeleteToken.for(user).to_s }
    let(:user) { create(:user) }

    it 'is a short cut for ProfileDeleteToken.for(user).to_s' do
      expect(subject).to eq(token)
    end
  end

  describe '#reachable?' do
    subject { user.reachable? }

    context 'when notifications are enabled' do
      let(:user) { build(:user, notifications_enabled: true) }

      it 'is false' do
        expect(subject).to be true
      end
    end

    context 'when notifications are disabled' do
      let(:user) { build(:user, notifications_enabled: false) }

      it 'is false' do
        expect(subject).to be false
      end
    end
  end

  describe '#avatar!' do
    context 'user has a avatar' do
      subject { user.avatar! }

      let(:user) { build(:user, :with_avatar) }

      it 'is a avatar' do
        expect(subject).to be_a(Avatar)
      end

      it 'belongs to the user' do
        expect(subject.user).to eq(user)
      end
    end

    context 'user has no avatar' do
      let(:user) { build(:user) }

      it 'raises ActiveRecord::RecordNotFound' do
        expect { user.avatar! }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#email_with_name' do
    subject { user.email_with_name }

    let(:user) { build(:user) }

    it 'is a header friendly combination of username and email' do
      expect(subject).to eq("#{user.username} <#{user.email}>")
    end
  end
end
