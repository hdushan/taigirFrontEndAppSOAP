class CarPremiumCalculatorClient

  def initialize(wsdl_url_base)
    
    @calculator = Savon.client do
      endpoint "#{wsdl_url_base}/calculator_service"
      namespace "http://www.hans.com/calculator"
      log true
    end
    
    @premium = nil
  end

  def getPremiumForQuote(quote)
    if @premium == nil
      response = @calculator.call(:car_premium_request) do
        xml "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cal=\"http://www.hans.com/calculator\">
   <soapenv:Header/>
   <soapenv:Body>
      <cal:CarPremiumRequest>
         <cal:age>#{quote.age}</cal:age>
         <cal:gender>#{quote.gender}</cal:gender>
         <cal:state>#{quote.state}</cal:state>
         <cal:make>#{quote.make}</cal:make>
         <cal:year>#{quote.year}</cal:year>
      </cal:CarPremiumRequest>
   </soapenv:Body>
</soapenv:Envelope>"
      end
      @premium = ('%.2f'%(response.body[:car_premium_response][:car_premium]))
    end
    @premium
  end
  
end