require 'rails_helper'

describe AuthToken do
  it 'inherits from ApplicationToken' do
    expect(AuthToken).to be < ApplicationToken
  end

  describe '.ttl' do
    let(:ttl) { AuthToken.ttl }

    it 'is 1 week' do
      expect(ttl).to eq(1.week)
    end
  end

  describe '.scope' do
    let(:scope) { AuthToken.scope }

    it 'is :auth' do
      expect(scope).to eq(:auth)
    end
  end
end
