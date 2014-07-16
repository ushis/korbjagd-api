require 'rails_helper'

describe ProfileDeleteToken do
  it 'inherits from ApplicationToken' do
    expect(ProfileDeleteToken).to be < ApplicationToken
  end

  describe '.ttl' do
    let(:ttl) { ProfileDeleteToken.ttl }

    it 'is 5 minutes' do
      expect(ttl).to eq(5.minutes)
    end
  end

  describe '.scope' do
    let(:scope) { ProfileDeleteToken.scope }

    it 'is :profile_delete' do
      expect(scope).to eq(:profile_delete)
    end
  end
end
