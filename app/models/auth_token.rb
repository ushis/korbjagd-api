class AuthToken < Struct.new(:id, :exp)

  # Default time to live
  TTL = 1.day

  # Returns a new auth token for a user
  def self.for(user, ttl=TTL)
    new(user.id, ttl.from_now.to_i)
  end

  # Returns an auth token from a token string
  #
  # Raises JWT::DecodeError on failure
  def self.from_s(token)
    decode(token).tap do |t|
      raise JWT::DecodeError.new('Token expired') if t.expired?
    end
  end

  # Returns true if the token is expired else false
  def expired?
    exp < Time.now.to_i
  end

  # Encodes the token to a string
  def to_s
    JWT.encode(to_h, ENV['JWT_KEY'])
  end

  private

  # Decodes a token string
  #
  # Raises JWT::DecodeError on failure
  def self.decode(token)
    payload, _ = JWT.decode(token, ENV['JWT_KEY'])
    new(payload['id'], payload['exp'])
  end
end
