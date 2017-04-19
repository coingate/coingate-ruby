# CoinGate Ruby Gem

CoinGate Bitcoin payment gateway.

## Installation

Sign up for CoinGate account at <https://coingate.com> for live (production) and <https://sandbox.coingate.com> for testing (sandbox) environment.

Please note, that for Sandbox you must generate separate API credentials on <https://sandbox.coingate.com>. API credentials generated on <https://coingate.com> will not work for Sandbox mode.

Add this line to your application's Gemfile:

```ruby
gem 'coingate'
```

And then execute:

    $ bundle

Or install it yourself by executing:

    $ gem install coingate
    
## Usage

### Create API credentials

To create API credentials go to <https://coingate.com> for production or <https://sandbox.coingate.com> for testing environment

### Setup CoinGate library

You can set default configuration like this:

```ruby
CoinGate.config do |config|
  config.app_id      = 1
  config.api_key     = 'get_your_key_at_coingatecom'
  config.api_secret  = 'get_your_key_at_coingatecom'
  config.environment = 'live' # live or sandbox. Default: live
end
```

Or you can pass authentication params individually, for example:

```ruby
CoinGate::Merchant::Order.find(1, {app_id: 1, api_key: 'coingate', api_secret: 'coingate', environment: 'sandbox'})
```

### Create Order

#### CoinGate::Merchant::Order#create

```ruby
post_params = {
  order_id:         'ORDER-1412759367',
  price:            1050.99,
  currency:         'USD',
  receive_currency: 'EUR',
  callback_url:     'https://example.com/payments/callback?token=6tCENGUYI62ojkuzDPX7Jg',
  cancel_url:       'https://example.com/cart',
  success_url:      'https://example.com/account/orders',
  description:      'Apple Iphone 6'
}

order = CoinGate::Merchant::Order.create(post_params)

if order
  # success
else
  # order is not valid
end
```

#### CoinGate::Merchant::Order#create!

```ruby
post_params = {
  order_id:         'ORDER-1412759367',
  price:            1050.99,
  currency:         'USD',
  receive_currency: 'EUR',
  callback_url:     'https://example.com/payments/callback?token=6tCENGUYI62ojkuzDPX7Jg',
  cancel_url:       'https://example.com/cart',
  success_url:      'https://example.com/account/orders',
  description:      'Apple Iphone 6'
}

# Raises exception if order is not valid.
order = CoinGate::Merchant::Order.create!(post_params)
```

### Find Order

#### CoinGate::Merchant::Order.find

```ruby
order = CoinGate::Merchant::Order.find(1)

if order
  # success
else
  # order not found
end
```

#### CoinGate::Merchant::Order.find!

```ruby
# Raises exception when order is not found
order = CoinGate::Merchant::Order.find!(1)
```
