class ApplicationToken < Struct.new(:id, :exp, :scope)

  # Default time to live
  TTL = 1.day

  # Returns the tokens scope
  def self.scope
    self.to_s
  end

  # Returns a new token for a record
  def self.for(record, ttl=TTL)
    new(record.id, ttl.from_now.to_i, self.scope)
  end

  # Returns a token from a token string
  #
  # Raises JWT::DecodeError on failure
  def self.from_s(token)
    decode(token).tap do |t|
      raise JWT::DecodeError.new('Token expired') if t.expired?
      raise JWT::DecodeError.new('Token out of scope') if t.invalid_scope?
    end
  end

  # Returns true if the token is expired else false
  def expired?
    exp < Time.now.to_i
  end

  # Returns true if the token is in scope else false
  def valid_scope?
    scope == self.class.scope
  end

  # Same as valid_scope? but the other way around
  def invalid_scope?
    ! valid_scope?
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
    new(payload['id'], payload['exp'], payload['scope'])
  end
end
