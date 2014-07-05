class DataUrlFile < StringIO
  attr_accessor :content_type
  attr_accessor :original_filename

  PREFIX_PATTERN = /\Adata:([^\/]+\/[^;]+);base64\z/

  def initialize(s)
    prefix, data = s.to_s.split(',', 2)

    if prefix.blank? || data.blank?
      raise ArgumentError.new('Invalid data url')
    end

    matcher = PREFIX_PATTERN.match(prefix)

    unless matcher
      raise ArgumentError.new('Invalid data url')
    end

    super(Base64.decode64(data))
    @content_type = matcher[1]
    @original_filename = [SecureRandom.uuid, ext].compact.join('.')
  end

  private

  def ext
    MIME::Types[@content_type].first.try(:extensions).try(:first)
  end
end
