class DataUrlFile < StringIO
  attr_accessor :content_type
  attr_accessor :original_filename

  PREFIX_PATTERN = /\Adata:([^\/]+\/[^;]+);base64\z/

  def initialize(s)
    prefix, data = s.to_s.split(',')

    if prefix.blank? || data.blank?
      raise ArgumentError.new('Invalid data url')
    end

    matcher = PREFIX_PATTERN.match(prefix)

    unless matcher
      raise ArgumentError.new('Invalid data url')
    end

    type = matcher[1]

    super(Base64.decode64(data))
    @content_type = type
    @original_filename = "#{SecureRandom.uuid}.#{type.split('/')[1]}"
  end
end
