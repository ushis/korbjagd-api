class ApplicationToken < Struct.new(:id, :exp, :scope)
  class_attribute :ttl_value, :scope_value, instance_accessor: false

  # Returns (and sets) the tokens ttl
  def self.ttl(ttl=nil)
    if !ttl.nil?
      self.ttl_value = ttl
    elsif !ttl_value.nil?
      self.ttl_value
    else
      raise NotImplementedError.new('The tokens time to life is not specified.')
    end
  end

  # Returns (and sets) the tokens scope
  def self.scope(scope=nil)
    if !scope.nil?
      self.scope_value = scope
    elsif !scope_value.nil?
      self.scope_value
    else
      raise NotImplementedError.new('The tokens scope is not specified.')
    end
  end

  # Returns a new token for a record
  def self.for(record)
    new(record.id, ttl.from_now.to_i, scope)
  end

  # Returns a token from a token string
  #
  # Raises JWT::DecodeError or JWT::ExpiredSignature on failure
  def self.from_s(token)
    decode(token).tap do |t|
      raise JWT::DecodeError.new('Token out of scope') if t.invalid_scope?
    end
  end

  # Returns true if the token is expired else false
  def expired?
    exp < Time.now.to_i
  end

  # Returns true if the token is in scope else false
  def valid_scope?
    scope.to_s == self.class.scope.to_s
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
