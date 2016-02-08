class CarPremiumCalculatorClient
  
  attr_accessor :wsdl_url

  def initialize
    @wsdl_url = "#{$calculator_service_url}/calculator_service/wsdl"
    @calculator = Savon.client(
          :wsdl => @wsdl_url,
          :soap_header => {"Token" => "secret"},
          :namespace => "http://www.hans.com/calculator",
          :log => true
    )
    @premium = nil
  end

  def getPremiumForQuote(quote)
    if @premium == nil
      response = @calculator.call(:car_premium, message: {age: quote.age, gender: quote.gender, state: quote.state, make: quote.make, year: "2000"})
      @premium = ('%.2f'%(response.body[:car_premium_response][:car_premium]))
    end
    @premium
  end
  
end