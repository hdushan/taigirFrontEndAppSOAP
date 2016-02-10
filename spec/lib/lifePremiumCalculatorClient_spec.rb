require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../pact_helper'
require 'lifePremiumCalculatorClient'

set :environment, :test

describe LifePremiumCalculatorClient, :pact => true do

  $calculator_service_url = "http://localhost:9000"
  carCalcClient = LifePremiumCalculatorClient.new($calculator_service_url)

  describe "life_premium" do

    before do
      calculator_service.given("LifePremiumRequest").
        upon_receiving("a request for a life premium").
        with(method: :post, path: '/calculator_service', body: /LifePremiumRequest/).
        will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'text/xml'},
          body: "<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:calculator=\"http://www.hans.com/calculator\">
   <SOAP:Body>
      <calculator:LifePremiumResponse>
         <calculator:LifePremium>47.95</calculator:LifePremium>
      </calculator:LifePremiumResponse>
   </SOAP:Body>
</SOAP:Envelope>" )

    end

    it "returns right premium" do
      expect(LifeQuote.new(23, "hans@tw.com", "nsw", "risk0", "male").premium).to eq('47.95')
    end
  end

end