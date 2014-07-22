class Sector < ActiveRecord::Base
  has_many :baskets, inverse_of: :sector

  # Length of one side of the sector square
  SIZE = 6

  # Most south west point possible
  SOUTH_WEST = Point.new(-90.0, -180.0)

  # Most north east point possible
  NORTH_EAST = Point.new(90.0, 180.0)

  # Number of sectors per column
  ROWS = ((NORTH_EAST.lat - SOUTH_WEST.lat) / SIZE).ceil

  # Number of Sectors per row
  COLS = ((NORTH_EAST.lng - SOUTH_WEST.lng) / SIZE).ceil

  validates :id, presence: true, numericality:
    {only_integer: true, greater_than_or_equal_to: 0, less_than: ROWS * COLS}

  # Returns a sector found or created by id
  #
  # Raises ActiveRecord::RecordInvalid for invalid ids
  def self.find_or_create_by_id(id)
    find_or_create_by!(id: id.to_i)
  rescue ActiveRecord::RecordNotUnique
    retry
  end

  # Returns the sector including the given point or nil
  #
  # Raises ActiveRecord::RecordInvalid for invalid points
  def self.find_or_create_by_point(point)
    if point.valid?
      x = (point.lng - SOUTH_WEST.lng).div(SIZE)
      y = (point.lat - SOUTH_WEST.lat).div(SIZE)
      find_or_create_by_id((x * ROWS) + y)
    else
      raise ActiveRecord::RecordInvalid.new(point)
    end
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
end
