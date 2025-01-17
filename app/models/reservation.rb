class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :guest_and_host_not_same
  validate :available
  validate :checkin_before_checkout


  def duration
    (checkout - checkin).to_i 
  end

  def total_price 
    (listing.price * duration)
  end

  private

  def available
    Reservation.where(listing_id: listing.id).where.not(id: id).each do |r|
      booked_dates = r.checkin..r.checkout
      if booked_dates === checkin || booked_dates === checkout
        errors.add(:guest_id, "Sorry, this place isn't available during your requested dates.")
      end
    end
  end

  def guest_and_host_not_same
    if guest_id == listing.host_id
      errors.add(:guest_id, "You Can't book your own apartment.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
      errors.add(:guest_id, "Your checkin date needs to be before your checkout date.")
    end
  end

end
