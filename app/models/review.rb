class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :description, presence: true
  validates :rating, presence: true
  validates :reservation, presence: true

  validate :checked_out
  validate :reservation_accepted



  private

    def checked_out
      if reservation && reservation.checkout > Date.today
        errors.add(:guest_id, "You can't review until after the checkout date.")
      end
    end

    def reservation_accepted
      if reservation.try(:status) != 'accepted'
        errors.add(:reservation, "Reservation must be accepted to leave a review.")
      end
    end
  

end
