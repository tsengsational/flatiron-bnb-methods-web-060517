class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(checkin, checkout)
    listings.select { |listing| listing.reservations.all? { |reservation|
      (checkin.to_datetime >= reservation.checkout.to_datetime) || (checkout.to_datetime <= reservation.checkin.to_datetime)
      }}
      # binding.pry
    end

    def self.highest_ratio_res_to_listings
      # binding.pry
      listings = self.all.each_with_object({}) { |neighborhood, neighborhoods| neighborhoods[neighborhood.name] = neighborhood.listings.size }

      reservations = self.all.each_with_object({}) { |neighborhood, neighborhoods| neighborhoods[neighborhood.name] = neighborhood.listings.map { |listing| listing.reservations }.flatten.size}

      ratios = listings.each_with_object({}) { |(neighborhood, listing_count), hash|
        if listing_count == 0
          hash[neighborhood] = 0
        else
          hash[neighborhood] = (reservations[neighborhood]/listing_count)
        end
      }
      # binding.pry
      winner = ratios.max_by{|neighborhood, ratio| ratio}.first

      self.all.find_by(name: winner)
    end

    def self.most_res
      reservations = self.all.each_with_object({}) { |neighborhood, neighborhoods| neighborhoods[neighborhood.name] = neighborhood.listings.map { |listing| listing.reservations }.flatten.size}
      name = reservations.max_by{|neighborhood, res| res}.first
      self.find_by(name: name)
      # binding.pry
    end

  end
