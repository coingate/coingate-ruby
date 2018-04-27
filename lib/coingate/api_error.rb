module CoinGate
  class APIError < ::RuntimeError; end

  # HTTP Status 400
  class BadRequest < APIError; end
  class AuthTokenMissing < BadRequest; end
  class BadEnvironment < BadRequest; end

  # HTTP Status 401
  class Unauthorized < APIError; end
  class BadAuthToken < Unauthorized; end

  # HTTP Status 404
  class NotFound < APIError; end
  class PageNotFound < NotFound; end
  class RecordNotFound < NotFound; end
  class OrderNotFound < NotFound; end

  # HTTP Status 422
  class UnprocessableEntity < APIError; end
  class OrderIsNotValid < UnprocessableEntity; end
  
  # HTTP Status 429
  class RateLimitException < UnprocessableEntity; end

  # HTTP Status 500
  class InternalServerError < APIError; end
end