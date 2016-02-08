class LifePremiumCalculatorClient

  def initialize
    @wsdl_url = "#{$calculator_service_url}/calculator_service/wsdl"
    @calculator = Savon.client(
          :wsdl => @wsdl_url,
          :soap_header => {"Token" => "secret"},
          :namespace => "http://www.hans.com/calculator",
          :log => true
    )
  end
  
  def getPremiumForQuote(quote)
    response = @calculator.call(:life_premium, message: {age: quote.age, gender: quote.gender, state: quote.state, occupationCategory: quote.occupationCategory})
    ('%.2f'%(response.body[:life_premium_response][:life_premium]))
  end
  
end