require 'rails_helper'

describe ApplicationToken do
  describe '::TTL' do
    let(:ttl) { ApplicationToken::TTL }

    it 'is 1 day' do
      expect(ttl).to eq(1.day)
    end
  end

  describe '.scope' do
    let(:scope) { ApplicationToken.scope }

    it 'is "ApplicationToken"' do
      expect(scope).to eq('ApplicationToken')
    end
  end

  describe '.for' do
    let(:user) { User.new(id: rand(1000)) }

    context 'without ttl' do
      let(:token) { ApplicationToken.for(user) }

      it 'has the same id as the record' do
        expect(token.id).to eq(user.id)
      end

      it 'expires in the default ttl' do
        expect(token.exp).to eq(ApplicationToken::TTL.from_now.to_i)
      end

      it 'has a valid scope' do
        expect(token.scope).to eq(ApplicationToken.scope)
      end
    end

    context 'with ttl' do
      let(:token) { ApplicationToken.for(user, ttl) }
      let(:ttl) { 3.days }

      it 'has the same id as the record' do
        expect(token.id).to eq(user.id)
      end

      it 'expires in the given ttl' do
        expect(token.exp).to eq(ttl.from_now.to_i)
      end

      it 'has the scope "ApplicationToken"' do
        expect(token.scope).to eq(ApplicationToken.scope)
      end
    end
  end

  describe '.from_s' do
    let(:token_string) { ApplicationToken.new(id, exp, scope).to_s }
    let(:id) { rand(1000) }

    context 'not expired' do
      let(:exp) { 2.days.from_now.to_i }

      context 'valid scope' do
        let(:scope) { ApplicationToken.scope }

        context 'valid signature' do
          let(:token) { ApplicationToken.from_s(token_string) }

          it 'is a ApplicationToken' do
            expect(token).to be_a(ApplicationToken)
          end

          it 'has the specified id' do
            expect(token.id).to eq(id)
          end

          it 'has the specified expiration date' do
            expect(token.exp).to eq(exp)
          end

          it 'has the specified scope' do
            expect(token.scope).to eq(scope)
          end
        end

        context 'invalid signature' do
          let(:token) { "#{token_string}x" }

          it 'raises an error' do
            expect {
              ApplicationToken.from_s(token)
            }.to raise_error(JWT::DecodeError)
          end
        end
      end

      context 'invalid scope' do
        let(:scope) { 'InvalidScope' }

        it 'raises an error' do
          expect {
            ApplicationToken.from_s(token_string)
          }.to raise_error(JWT::DecodeError)
        end
      end
    end

    context 'expired' do
      let(:exp) { 3.days.ago.to_i }

      context 'valid scope' do
        let(:scope) { ApplicationToken.scope }

        it 'raises an error' do
          expect {
            ApplicationToken.from_s(token_string)
          }.to raise_error(JWT::DecodeError)
        end
      end

      context 'invalid scope' do
        let(:scope) { 'InvalidScope' }

        it 'raises an error' do
          expect {
            ApplicationToken.from_s(token_string)
          }.to raise_error(JWT::DecodeError)
        end
      end
    end
  end

  describe '#expired?' do
    let(:expired?) { ApplicationToken.new(rand(1000), exp).expired? }

    context 'expired' do
      let(:exp) { 3.days.ago.to_i }

      it 'is true' do
        expect(expired?).to be true
      end
    end

    context 'not expired' do
      let(:exp) { 1.day.from_now.to_i }

      it 'is false' do
        expect(expired?).to be false
      end
    end
  end

  describe '#valid_scope?' do
    let(:valid_scope?) do
      ApplicationToken.new(rand(100), rand(100), scope).valid_scope?
    end

    context 'valid scope' do
      let(:scope) { ApplicationToken.scope }

      it 'is true' do
        expect(valid_scope?).to be true
      end
    end

    context 'invalid scope' do
      let(:scope) { 'InvalidScope' }

      it 'is false' do
        expect(valid_scope?).to be false
      end
    end
  end

  describe '#invalid_scope?' do
    let(:invalid_scope?) do
      ApplicationToken.new(rand(100), rand(100), scope).invalid_scope?
    end

    context 'valid scope' do
      let(:scope) { ApplicationToken.scope }

      it 'is false' do
        expect(invalid_scope?).to be false
      end
    end

    context 'invalid scope' do
      let(:scope) { 'InvalidScope' }

      it 'is true' do
        expect(invalid_scope?).to be true
      end
    end
  end

  describe '#to_s' do
    let(:token_string) { ApplicationToken.new(id, exp, scope).to_s }
    let(:scope) { ApplicationToken.scope }
    let(:exp) { 3.days.from_now }
    let(:id) { rand(1000) }

    it 'is a string' do
      expect(token_string).to be_a(String)
    end

    context 'with same attributes' do
      let(:other_token_string) { ApplicationToken.new(id, exp, scope).to_s }

      it 'must equal' do
        expect(token_string).to eq(other_token_string)
      end
    end

    context 'with different attributes' do
      let(:other_token_string) do
        ApplicationToken.new(other_id, other_exp, other_scope).to_s
      end

      context 'different id' do
        let(:other_scope) { scope }
        let(:other_exp) { exp }
        let(:other_id) { id + 534 }

        it 'does not equal' do
          expect(token_string).to_not eq(other_token_string)
        end
      end

      context 'different expiration date' do
        let(:other_scope) { scope }
        let(:other_exp) { exp - 779 }
        let(:other_id) { id }

        it 'does not equal' do
          expect(token_string).to_not eq(other_token_string)
        end
      end

      context 'different scope' do
        let(:other_scope) { 'AuthToken' }
        let(:other_exp) { exp }
        let(:other_id) { id }

        it 'does not equal' do
          expect(token_string).to_not eq(other_token_string)
        end
      end
    end
  end
end
