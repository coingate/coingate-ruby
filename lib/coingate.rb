require 'coingate/version'

require 'coingate/error_handler'
require 'coingate/api_error'

require 'coingate/merchant'
require 'coingate/merchant/order'

require 'openssl'
require 'rest_client'
require 'json'

module CoinGate
  class << self
    attr_accessor :auth_token, :environment

    def config
      yield self
    end

    def api_request(url, request_method = :post, params = {}, authentication = {})
      auth_token  = authentication[:auth_token] || self.auth_token
      environment = authentication[:environment] || self.environment || 'live'

      # Check if auth_token was passed
      if auth_token.nil?
        CoinGate.raise_error(400, {'reason' => 'AuthTokenMissing'})
      end

      # Check if right environment passed
      environments = %w(live sandbox)

      unless environments.include?(environment)
        CoinGate.raise_error(400, {'reason' => 'BadEnvironment', 'message' => "Environment does not exist. Available environments: #{environments.join(', ')}"})
      end

      url = (
      case environment
        when 'sandbox'
          'https://api-sandbox.coingate.com/v2'
        else
          'https://api.coingate.com/v2'
      end) + url

      headers = {
        Authorization: "Token #{auth_token}"
      }

      begin
        response = case request_method
          when :get
            RestClient.get(url, headers)
          when :post
            RestClient.post(url, params, headers.merge('Content-Type' => 'application/x-www-form-urlencoded'))
        end

        [response.code, JSON.parse(response.to_str)]
      rescue => e
        response = begin
          JSON.parse(e.response)
        rescue
          {'reason' => nil, 'message' => e.response}
        end

        CoinGate.raise_error(e.http_code, response)
      end
    end
  end
end