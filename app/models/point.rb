class Point < Struct.new(:latitude, :longitude)
  include ActiveModel::Validations

  validates :latitude,  presence: true, numericality: true
  validates :longitude, presence: true, numericality: true

  alias :lat  :latitude
  alias :lat= :latitude=

  alias :lng  :longitude
  alias :lng= :longitude=
end
