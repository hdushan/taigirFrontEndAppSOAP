require 'quote'
require 'carPremiumCalculatorClient'

class CarQuote < Quote
  
  attr_reader :year, :make, :premium
  
  @@makes = {"audi" => "Audi", "alfa" => "Alfa Romeo", "bmw" => "BMW", "lexus" => "Lexus", "toyota" => "Toyota", "vw" => "Volkswagen"}
    
  def initialize(age, email, state, make, gender, year, soapxml=false)
    @age = age.to_i
    @email = email
    @state = state
    @make = make
    @gender = gender
    @year = year
    super(:car, @age, @email, @state, @gender)
    if soapxml==true
      @premium = CarPremiumCalculatorClient.new($calculator_service_url).getPremiumForQuoteSOAP(self)
    else
      @premium = CarPremiumCalculatorClient.new($calculator_service_url).getPremiumForQuoteJSON(self)
    end
  end
  
  def namedMake
    @@makes[@make]
  end
  
end