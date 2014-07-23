class DataUrlUploader < CarrierWave::Uploader::Base

  # Represents a file build from a data url
  class DataUrlFile < StringIO
    attr_accessor :content_type
    attr_accessor :original_filename

    # Pattern matches the data url prefix
    PREFIX_PATTERN = /\Adata:([^\/]+\/[^;]+);base64\z/

    # Decodes a data url
    #
    # Raises ArgumentError on failure
    def initialize(s)
      prefix, data = s.to_s.split(',', 2)

      if prefix.blank? || data.blank?
        raise ArgumentError.new('Invalid data url')
      end

      matcher = PREFIX_PATTERN.match(prefix)

      if matcher.nil?
        raise ArgumentError.new('Invalid data url')
      end

      super(Base64.decode64(data))
      @content_type = matcher[1]
      @original_filename = filename
    end

    private

    # Guesses the file extension from the content type
    def ext
      MIME::Types[@content_type].first.try(:extensions).try(:first)
    end

    # Generates a filename
    def filename
      [SecureRandom.uuid, ext].compact.join('.')
    end
  end

  # Hook into CarrierWave
  def cache!(file)
    super(DataUrlFile.new(file))
  rescue ArgumentError => e
    raise CarrierWave::IntegrityError.new(e.to_s)
  end
end
