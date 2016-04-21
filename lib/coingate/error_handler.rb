module CoinGate
  def self.format_error(error)
    "#{error['reason']} #{error['message']}"
  end

  def self.raise_error(http_code, error={})
    reason = error['reason']

    raise (case http_code
      when 400
        case reason
          when 'CredentialsMissing' then CredentialsMissing
          when 'BadEnvironment' then BadEnvironment
          else BadRequest
        end

      when 401 then
        case reason
          when 'BadCredentials' then BadCredentials
          else Unauthorized
        end

      when 404 then
        case reason
          when 'PageNotFound' then PageNotFound
          when 'RecordNotFound' then RecordNotFound
          when 'OrderNotFound' then OrderNotFound
          else NotFound
        end


      when 422
        case reason
          when 'OrderIsNotValid' then OrderIsNotValid
          else UnprocessableEntity
        end

      when 500 then InternalServerError

      else APIError
    end), format_error(error)
  end
end

