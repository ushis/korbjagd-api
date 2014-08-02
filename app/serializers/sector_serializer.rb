class SectorSerializer < ActiveModel::Serializer
  attributes :id, :baskets_count, :south_west, :north_east, :created_at, :updated_at
end
