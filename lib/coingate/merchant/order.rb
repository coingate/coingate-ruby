class CoinGate::Merchant::Order
  STATUSES = %w(pending confirming paid invalid canceled expired failed)

  def initialize(params)
    @order = params

    @order.each do |name, value|
      self.define_singleton_method name do
        value
      end
    end
  end

  STATUSES.each do |type|
    define_method "#{type}?" do
      status == type
    end
  end

  def to_hash
    @order
  end

  def self.find!(order_id, authentication={}, options={})
    response_code, order = CoinGate.api_request("/orders/#{order_id}", :get, {}, authentication)

    if response_code == 200
      self.new(order)
    end
  end

  def self.find(order_id, authentication={}, options={})
    find!(order_id, authentication, options)
  rescue CoinGate::OrderNotFound
    false
  end

  def self.create!(params, authentication={}, options={})
    response_code, order = CoinGate.api_request('/orders', :post, params, authentication)

    if response_code == 200
      self.new(order)
    end
  end

  def self.create(params, authentication={}, options={})
    create!(params, authentication, options)
  rescue CoinGate::OrderIsNotValid
    false
  end
end