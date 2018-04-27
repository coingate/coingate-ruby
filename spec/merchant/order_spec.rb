require 'spec_helper'

describe CoinGate::Merchant::Order do
  include_context 'shared'

  let(:valid_order_params) do
    {
        order_id:         'ORDER-1412759367',
        price_amount:     1050.99,
        price_currency:   'USD',
        receive_currency: 'EUR',
        callback_url:     'https://example.com/payments/callback?token=6tCENGUYI62ojkuzDPX7Jg',
        cancel_url:       'https://example.com/cart',
        success_url:      'https://example.com/account/orders',
        description:      'Apple Iphone 6s'
    }
  end

  before do
    CoinGate.config do |config|
      config.auth_token  = @authentication[:auth_token]
      config.environment = @authentication[:environment]
    end
  end

  describe 'create order' do
    context 'invalid' do
      it { expect(CoinGate::Merchant::Order.create({})).to be false }
      it { expect { CoinGate::Merchant::Order.create!({}) }.to raise_error CoinGate::OrderIsNotValid }
    end

    context 'valid' do
      it { expect(CoinGate::Merchant::Order.create(valid_order_params).new?).to be true }
      it { expect(CoinGate::Merchant::Order.create!(valid_order_params).new?).to be true }
    end
  end

  describe 'find order' do
    context 'order exists' do
      it do
        order = CoinGate::Merchant::Order.create(valid_order_params)

        expect(CoinGate::Merchant::Order.find(order.id).new?).to be true
        expect(CoinGate::Merchant::Order.find!(order.id).new?).to be true
      end
    end

    context 'order does not exists' do
      it { expect(CoinGate::Merchant::Order.find(0)).to be false }
      it { expect { CoinGate::Merchant::Order.find!(0) }.to raise_error CoinGate::OrderNotFound }
    end
  end

  describe 'passing auth params through arguments' do
    before do
      CoinGate.config do |config|
        config.auth_token = nil
      end
    end

    describe 'create order' do
      context 'params not passed' do
        it { expect { CoinGate::Merchant::Order.create({}) }.to raise_error CoinGate::AuthTokenMissing }
        it { expect { CoinGate::Merchant::Order.create!({}) }.to raise_error CoinGate::AuthTokenMissing }
      end

      context 'invalid params passed' do
        authentication = {
          auth_token: 'a'
        }

        it { expect { CoinGate::Merchant::Order.create({}, authentication) }.to raise_error CoinGate::BadAuthToken }
        it { expect { CoinGate::Merchant::Order.create!({}, authentication) }.to raise_error CoinGate::BadAuthToken }
      end

      context 'valid params passed' do
        it { expect(CoinGate::Merchant::Order.create({}, @authentication)).to be false }
        it { expect { CoinGate::Merchant::Order.create!({}, @authentication) }.to raise_error CoinGate::OrderIsNotValid }
      end
    end

    describe 'find order' do
      context 'params not passed' do
        it { expect { CoinGate::Merchant::Order.find(0) }.to raise_error CoinGate::AuthTokenMissing }
        it { expect { CoinGate::Merchant::Order.find!(0) }.to raise_error CoinGate::AuthTokenMissing }
      end

      context 'invalid params passed' do
        authentication = {
          auth_token: 'a',
        }

        it { expect { CoinGate::Merchant::Order.find(0, authentication) }.to raise_error CoinGate::BadAuthToken }
        it { expect { CoinGate::Merchant::Order.find!(0, authentication) }.to raise_error CoinGate::BadAuthToken }
      end

      context 'valid params passed' do
        it { expect(CoinGate::Merchant::Order.find(0, @authentication)).to be false }
        it { expect { CoinGate::Merchant::Order.find!(0, @authentication) }.to raise_error CoinGate::OrderNotFound }
      end
    end
  end
end