require 'Date'
class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(date1, date2)
    openings = self.listings.select { |listing| listing.reservations.all? { |reservation|
      (date1.to_datetime >= reservation.checkout.to_datetime) || (date2.to_datetime <= reservation.checkin.to_datetime)
      }}
  end

  def self.highest_ratio_res_to_listings
    #find all the cities
    #iterate over each city
    #find the total number of reservations
    #find the total number of listings
    #divide the number of reservations.to_f by the number of listings.to_f
    listings = self.all.each_with_object({}) { |city, cities| cities[city.name] = city.listings.size  }

    reservations = self.all.each_with_object({}) { |city, cities| cities[city.name] = city.listings.map { |listing| listing.reservations }.flatten.size}

    ratios = listings.each_with_object({}) { |(city, listing_count), hash| hash[city] = (reservations[city].to_f/listing_count.to_f)}

    winner = ratios.max_by{|city, ratio| ratio}.first

    self.all.find_by(name: winner)
  end

  def self.most_res
    #get all cities, and iterate over each city
    #in a hash, find how many res each city has and assign the value to each city.
    #return the k/v pair with the highest number of reservations
    reservations = self.all.each_with_object({}) { |city, cities| cities[city.name] = city.listings.map { |listing| listing.reservations }.flatten.size}
    name = reservations.max_by{|city, res| res}.first
    self.find_by(name: name)
    # binding.pry
  end

end
