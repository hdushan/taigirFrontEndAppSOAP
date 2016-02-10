require 'quote'
require 'lifePremiumCalculatorClient'

class LifeQuote < Quote
  
  attr_reader :occupationCategory, :premium
  
  @@occupationCategories = {"risk0" => "Low risk occupation", "risk1" => "Medium risk occupation", "risk2" => "High risk occupation", "risk3" => "Very High risk occupation"}
    
  def initialize(age, email, state, occupationCategory, gender, soapxml=false)
    @age = age.to_i
    @email = email
    @state = state
    @occupationCategory = occupationCategory
    @gender = gender
    super(:life, @age, @email, @state, @gender)
    if soapxml==true
      @premium = LifePremiumCalculatorClient.new($calculator_service_url).getPremiumForQuoteSOAP(self)
    else
      @premium = LifePremiumCalculatorClient.new($calculator_service_url).getPremiumForQuoteJSON(self)
    end
  end
  
  def namedOccupationCategory
    @@occupationCategories[@occupationCategory]
  end
  
end