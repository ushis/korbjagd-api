require 'rails_helper'

describe PasswordResetToken do
  it 'inherits from ApplicationToken' do
    expect(PasswordResetToken).to be < ApplicationToken
  end

  describe '::TTL' do
    let(:ttl) { PasswordResetToken::TTL }

    it 'is 30 minutes' do
      expect(ttl).to eq(30.minutes)
    end
  end

  describe '.scope' do
    let(:scope) { PasswordResetToken.scope }

    it 'is "PasswordResetToken"' do
      expect(scope).to eq('PasswordResetToken')
    end
  end
end
