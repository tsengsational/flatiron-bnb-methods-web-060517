class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :invalid_same_ids
  validate :unoccupied
  validate :checkin_before_checkout

  def duration
    (checkout - checkin)
  end

  def total_price
    duration * listing.price
  end

  private

  def invalid_same_ids
    if listing.host == guest
      errors.add(:own_listing, "can't make a reservation on your own listing")
    end
  end

  def unoccupied
    # binding.pry
    if checkin && checkout
      listing.reservations.each { |reservation|
        if (reservation.checkin <= checkin && reservation.checkout >= checkin) || (reservation.checkin <= checkout && reservation.checkout >= checkout)
          errors.add(:unoccupied, "This listing is occupied during that time")
        end
      }
    end
  end

  def checkin_before_checkout
    if checkin && checkout
      if checkin >= checkout
        errors.add(:checkin_before_checkout, "Check in must be before check out")
      end
    end
  end


end
