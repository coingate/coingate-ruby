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
    attr_accessor :app_id, :api_key, :api_secret, :environment

    def config
      yield self
    end

    def api_request(url, request_method = :post, params = {}, authentication = {})
      app_id      = authentication[:app_id] || self.app_id
      api_key     = authentication[:api_key] || self.api_key
      api_secret  = authentication[:api_secret] || self.api_secret
      environment = authentication[:environment] || self.environment || 'live'

      # Check if credentials was passed
      if app_id.nil? || api_key.nil? || api_secret.nil?
        CoinGate.raise_error(400, {'reason' => 'CredentialsMissing'})
      end

      # Check if right environment passed
      environments = %w(live sandbox)

      unless environments.include?(environment)
        CoinGate.raise_error(400, {'reason' => 'BadEnvironment', 'message' => "Environment does not exist. Available environments: #{environments.join(', ')}"})
      end

      url = (
      case environment
        when 'sandbox'
          'https://sandbox.coingate.com/api/v1'
        else
          'https://coingate.com/api/v1'
      end) + url

      nonce     = (Time.now.to_f * 1e6).to_i
      message   = nonce.to_s + app_id.to_s + api_key
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), api_secret, message)

      headers = {
          'Access-Nonce'     => nonce,
          'Access-Key'       => api_key,
          'Access-Signature' => signature
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