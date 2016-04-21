require 'spec_helper'

describe CoinGate::Merchant::Order do
  include_context 'shared'

  let(:valid_order_params) do
    {
        order_id:         'ORDER-1412759367',
        price:            1050.99,
        currency:         'USD',
        receive_currency: 'EUR',
        callback_url:     'https://example.com/payments/callback?token=6tCENGUYI62ojkuzDPX7Jg',
        cancel_url:       'https://example.com/cart',
        success_url:      'https://example.com/account/orders',
        description:      'Apple Iphone 6s'
    }
  end

  before do
    CoinGate.config do |config|
      config.app_id      = @authentication[:app_id]
      config.api_key     = @authentication[:api_key]
      config.api_secret  = @authentication[:api_secret]
      config.environment = @authentication[:environment]
    end
  end

  describe 'create order' do
    context 'invalid' do
      it { expect(CoinGate::Merchant::Order.create({})).to be false }
      it { expect { CoinGate::Merchant::Order.create!({}) }.to raise_error CoinGate::OrderIsNotValid }
    end

    context 'valid' do
      it { expect(CoinGate::Merchant::Order.create(valid_order_params).pending?).to be true }
      it { expect(CoinGate::Merchant::Order.create!(valid_order_params).pending?).to be true }
    end
  end

  describe 'find order' do
    context 'order exists' do
      it do
        order = CoinGate::Merchant::Order.create(valid_order_params)

        expect(CoinGate::Merchant::Order.find(order.id).pending?).to be true
        expect(CoinGate::Merchant::Order.find!(order.id).pending?).to be true
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
        config.app_id      = nil
        config.api_key     = nil
        config.api_secret  = nil
        config.environment = nil
      end
    end

    describe 'create order' do
      context 'params not passed' do
        it { expect { CoinGate::Merchant::Order.create({}) }.to raise_error CoinGate::CredentialsMissing }
        it { expect { CoinGate::Merchant::Order.create!({}) }.to raise_error CoinGate::CredentialsMissing }
      end

      context 'invalid params passed' do
        authentication = {
            app_id: 1,
            api_key: 'a',
            api_secret: 'a'
        }

        it { expect { CoinGate::Merchant::Order.create({}, authentication) }.to raise_error CoinGate::BadCredentials }
        it { expect { CoinGate::Merchant::Order.create!({}, authentication) }.to raise_error CoinGate::BadCredentials }
      end

      context 'valid params passed' do
        it { expect(CoinGate::Merchant::Order.create({}, @authentication)).to be false }
        it { expect { CoinGate::Merchant::Order.create!({}, @authentication) }.to raise_error CoinGate::OrderIsNotValid }
      end
    end

    describe 'find order' do
      context 'params not passed' do
        it { expect { CoinGate::Merchant::Order.find(0) }.to raise_error CoinGate::CredentialsMissing }
        it { expect { CoinGate::Merchant::Order.find!(0) }.to raise_error CoinGate::CredentialsMissing }
      end

      context 'invalid params passed' do
        authentication = {
            app_id: 1,
            api_key: 'a',
            api_secret: 'a'
        }

        it { expect { CoinGate::Merchant::Order.find(0, authentication) }.to raise_error CoinGate::BadCredentials }
        it { expect { CoinGate::Merchant::Order.find!(0, authentication) }.to raise_error CoinGate::BadCredentials }
      end

      context 'valid params passed' do
        it { expect(CoinGate::Merchant::Order.find(0, @authentication)).to be false }
        it { expect { CoinGate::Merchant::Order.find!(0, @authentication) }.to raise_error CoinGate::OrderNotFound }
      end
    end
  end
end