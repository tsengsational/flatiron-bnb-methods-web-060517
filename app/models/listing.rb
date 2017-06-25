class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validate :has_address
  validate :has_listing_type
  validate :has_title
  validate :has_description
  validate :has_price
  validate :has_neighborhood

  after_create :after_create
  after_destroy :after_destroy

  def average_review_rating
    reviews.average(:rating)
  end

  private

  def has_address
    if self.address == nil
      errors.add(:address, "can't be blank")
    end
  end

  def has_listing_type
    if self.listing_type == nil
      errors.add(:listing_type, "can't be blank")
    end
  end

  def has_title
    if self.title == nil
      errors.add(:title, "can't be blank")
    end
  end

  def has_description
    if self.description == nil
      errors.add(:description, "can't be blank")
    end
  end

  def has_price
    if self.price == nil
      errors.add(:price, "can't be blank")
    end
  end

  def has_neighborhood
    if self.neighborhood == nil
      errors.add(:neighborhood, "can't be blank")
    end
  end

  def after_create
    self.host.update(host: true)
    # binding.pry
  end

  def after_destroy
    self.host.update(host: false) if !self.host.listings.any?
  end

end
