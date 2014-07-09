require 'rails_helper'

describe PasswordResetToken do
  it 'inherits from ApplicationToken' do
    expect(PasswordResetToken).to be < ApplicationToken
  end

  describe '.ttl' do
    let(:ttl) { PasswordResetToken.ttl }

    it 'is 30 minutes' do
      expect(ttl).to eq(30.minutes)
    end
  end

  describe '.scope' do
    let(:scope) { PasswordResetToken.scope }

    it 'is :password_reset' do
      expect(scope).to eq(:password_reset)
    end
  end
end
