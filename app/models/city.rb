class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings 

  include Reservable

  def city_openings(start, ending)
    start_date = Date.parse(start.to_s)
    end_date = Date.parse(ending.to_s)
    openings = []
    self.listings.each do |n|
      n.reservations.each do |r|
      if r.checkin >= start_date && r.checkin <= end_date 
        openings << n
      end
    end
    end
    return openings
  end

  
  


end

