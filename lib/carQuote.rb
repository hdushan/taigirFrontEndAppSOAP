require 'quote'
require 'carPremiumCalculatorClient'

class CarQuote < Quote
  
  attr_reader :year, :make, :premium
  
  @@makes = {"audi" => "Audi", "alfa" => "Alfa Romeo", "bmw" => "BMW", "lexus" => "Lexus", "toyota" => "Toyota", "vw" => "Volkswagen"}
    
  def initialize(age, email, state, make, gender, year)
    @age = age.to_i
    @email = email
    @state = state
    @make = make
    @gender = gender
    @year = year
    super(:car, @age, @email, @state, @gender)
    @premium = CarPremiumCalculatorClient.new.getPremiumForQuote(self)
  end
  
  def namedMake
    @@makes[@make]
  end
  
end