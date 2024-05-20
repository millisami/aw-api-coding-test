# Service class to handle jwt tokens
class AuthTokenService
  HMAC_SECRET = Rails.application.credentials.secret_key_base
  ALGORITHM_TYPE = "HS256".freeze

  def self.call(user_id)
    expiry = 24.hours.from_now.to_i
    payload = { user_id: user_id, expiry: expiry }
    JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
  end

  def self.decode(token)
    JWT.decode token, HMAC_SECRET, true, { algorithm: ALGORITHM_TYPE }
  rescue JWT::ExpiredSignature, JWT::DecodeError
    false
  end

  def self.valid_payload(payload)
    !expired(payload)
  end

  def self.expired(payload)
    Time.at(payload['expiry']) < Time.now
  end

  def self.expired_token
    render json: { error: 'Token expired. Login again to refresh' }, status: :unauthorized
  end
end
