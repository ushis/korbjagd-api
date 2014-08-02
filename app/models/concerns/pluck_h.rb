module PluckH
  extend ActiveSupport::Concern

  module ClassMethods
    # Like ActiveRecord::Calculations#pluck, but builds a hash for each row.
    #
    #   class Basket < ActiveRecord::Base
    #     include PluckH
    #   end
    #
    #   Basket.where('id < 10').pluck_h(:id, :latitude, :longitude)
    #   #=> [
    #   #     {id: 1, latitude: 12.123, longitude: -123.312},
    #   #     {id: 4, latitude: 34.322, longitude: 23.123},
    #   #     {id: 7, latitude: -9.276, longitude: 45.953}
    #   #   ]
    #
    # Usefull for fast serialization.
    def pluck_h(*cols)
      pluck(*cols).map { |row| Hash[cols.zip(row)] }
    end
  end
end
