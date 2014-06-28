class Point < Struct.new(:latitude, :longitude)

  # Parses multiple point strings.
  def self.parse_all(strings)
    Array.wrap(strings).map { |s| from_s(s) }
  end

  # Same as ::from_s! but returns the origin for invalid input.
  def self.from_s(s)
    from_s!(s.to_s)
  rescue ArgumentError
    new(0.0, 0.0)
  end

  # Parses a point string.
  #
  #   Point.from_s('123.1234523,13.21355')
  #   #=> #<struct Point latitude=123.1234523, longitude=13.21355>
  #
  # Raises ArgumentError for invalid input.
  def self.from_s!(s)
    coords = s.split(',')

    if coords.length != 2
      raise ArgumentError.new("Invalid point string: #{s}")
    else
      new(*coords.map(&:to_f))
    end
  end

  # Builds a new point
  def initialize(lat=0.0, lng=0.0)
    super(lat, lng)
  end

  alias :lat  :latitude
  alias :lat= :latitude=

  alias :lng  :longitude
  alias :lng= :longitude=
end
