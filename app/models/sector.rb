class Sector < ActiveRecord::Base
  has_many :baskets, inverse_of: :sector

  # Length of one side of the sector square
  SIZE = 6

  # Most south west point possible
  SOUTH_WEST = Point.new(-90.0, -180.0)

  # Most north east point possible
  NORTH_EAST = Point.new(90.0, 180.0)

  # Number of sectors per column
  ROWS = (NORTH_EAST.lat - SOUTH_WEST.lat) / SIZE

  # Number of Sectors per row
  COLS = (NORTH_EAST.lng - SOUTH_WEST.lng) / SIZE

  # Returns a sector found by id
  #
  # Raises ActiveRecord::RecordNotFound on error
  def self.find(id)
    if valid_id?(id)
      find_or_initialize_by(id: id.to_i)
    else
      raise ActiveRecord::RecordNotFound.new("Couldn't find Sector with 'id'=#{id}")
    end
  end

  # Returns the sector including the given point or nil
  def self.around(point)
    return nil unless valid_point?(point)
    x = (point.lng - SOUTH_WEST.lng).div(SIZE)
    y = (point.lat - SOUTH_WEST.lat).div(SIZE)
    find_or_initialize_by(id: (x * ROWS) + y)
  end

  # Returns the south boundary
  def south
    @south ||= id.modulo(ROWS) * SIZE + SOUTH_WEST.lat
  end

  # Returns the west boundary
  def west
    @west ||= id.div(ROWS) * SIZE + SOUTH_WEST.lng
  end

  # Returns the north boundary
  def north
    @north ||= south + SIZE
  end

  # Returns the east boundary
  def east
    @east ||= west + SIZE
  end

  # Returns the most south west point of the sector
  def south_west
    @south_west ||= Point.new(south, west)
  end

  # Returns the most north east point of the sector
  def north_east
    @north_east ||= Point.new(north, east)
  end

  # Returns true if the sector includes the given point else false
  def include?(pnt)
    pnt.lat >= south && pnt.lng >= west && pnt.lat < north && pnt.lng < east
  end

  private

  # Returns true if the passed id is valid else false
  def self.valid_id?(id)
    id = id.to_i
    id >= 0 && id < ROWS * COLS
  end

  # Returns true if the passed point is valid else false
  def self.valid_point?(point)
    point.is_a?(Point) && point.valid? &&
      point.lat > SOUTH_WEST.lat && point.lng > SOUTH_WEST.lng &&
      point.lat < NORTH_EAST.lat && point.lng < NORTH_EAST.lng
  end
end
