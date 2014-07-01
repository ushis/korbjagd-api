class Point < Struct.new(:latitude, :longitude)

  # Parses multiple point strings.
  def self.parse_all(strings)
    Array.wrap(strings).map { |s| from_s(s) rescue nil }.compact
  end

  # Parses a point string.
  #
  #   Point.from_s('123.1234523,13.21355')
  #   #=> #<struct Point latitude=123.1234523, longitude=13.21355>
  #
  # Raises ArgumentError for invalid input.
  def self.from_s(s)
    coords = s.split(',')

    if coords.length != 2
      raise ArgumentError.new("Invalid point string: #{s}")
    else
      new(*coords.map { |c| Float(c) })
    end
  end

  alias :lat  :latitude
  alias :lat= :latitude=

  alias :lng  :longitude
  alias :lng= :longitude=
end
