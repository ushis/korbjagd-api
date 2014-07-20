class Point < Struct.new(:latitude, :longitude)
  include ActiveModel::Validations

  validates :latitude,  presence: true, numericality: true
  validates :longitude, presence: true, numericality: true

  alias :lat  :latitude
  alias :lat= :latitude=

  alias :lng  :longitude
  alias :lng= :longitude=

  # Returns a string representation of the point
  def to_s
    "(#{latitude},#{longitude})"
  end
end
