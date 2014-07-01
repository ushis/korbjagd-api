class Bounds < Struct.new(:south_west, :north_east)

  # Builds new bounds from some points
  def self.build(*points)
    new.tap do |bounds|
      points.each { |point| bounds.extend(point) }
    end
  end

  # Extends the bounds if necessary
  def extend(point)
    extend_south_west(point)
    extend_north_east(point)
  end

  # Returns the south boundary
  def south
    south_west.try(:lat)
  end

  # Returns the west boundary
  def west
    south_west.try(:lng)
  end

  # Returns the north boundary
  def north
    north_east.try(:lat)
  end

  # Returns the east boundary
  def east
    north_east.try(:lng)
  end

  alias :s :south
  alias :w :west
  alias :n :north
  alias :e :east

  alias :sw  :south_west
  alias :sw= :south_west=

  alias :ne  :north_east
  alias :ne= :north_east=

  private

  # Extends the south west point if necessary
  def extend_south_west(point)
    if south_west.nil?
      self.south_west = point.dup
    else
      south_west.lat = point.lat if south_west.lat > point.lat
      south_west.lng = point.lng if south_west.lng > point.lng
    end
  end

  # Extends the nort east point if necessary
  def extend_north_east(point)
    if north_east.nil?
      self.north_east = point.dup
    else
      north_east.lat = point.lat if north_east.lat < point.lat
      north_east.lng = point.lng if north_east.lng < point.lng
    end
  end
end
