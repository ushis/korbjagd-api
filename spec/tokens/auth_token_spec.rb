require 'rails_helper'

describe AuthToken do
  it 'inherits from ApplicationToken' do
    expect(AuthToken).to be < ApplicationToken
  end

  describe '::TTL' do
    let(:ttl) { AuthToken::TTL }

    it 'is 1 day' do
      expect(ttl).to eq(1.day)
    end
  end

  describe '.scope' do
    let(:scope) { AuthToken.scope }

    it 'is "AuthToken"' do
      expect(scope).to eq('AuthToken')
    end
  end
end
