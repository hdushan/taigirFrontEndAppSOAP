require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../pact_helper'
require 'carPremiumCalculatorClient'

set :environment, :test

describe CarPremiumCalculatorClient, :pact => true do

   $calculator_service_url = "http://localhost:9000"
   carCalcClient = CarPremiumCalculatorClient.new($calculator_service_url)

  describe "car_premium" do

    before do
      # calculator_service.given("CarPremiumRequest").
#         upon_receiving("a request for a car premium").
#         with(method: :post, path: '/calculator_service', body: /LifePremiumRequest/).
#         will_respond_with(
#           status: 200,
#           headers: {'Content-Type' => 'text/xml;charset=utf-8'},
#           body: "<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:calculator=\"http://www.hans.com/calculator\">
#    <SOAP:Body>
#       <calculator:CarPremiumResponse>
#          <calculator:CarPremium>55.54</calculator:CarPremium>
#       </calculator:CarPremiumResponse>
#    </SOAP:Body>
# </SOAP:Envelope>" )

      calculator_service.given("CarPremiumRequest").
        upon_receiving("a JSON request for a car premium").
        with(method: :get, path: '/car_premium', query: 'age=23&gender=male&make=bmw&state=nsw')
			  .will_respond_with(
				status: 200,
				headers: {"Content-Type" => "application/json"},
				body: {
					price: 55.54
				}
			)

    end

    it "returns right premium" do
      expect(CarQuote.new(23, "hans@tw.com", "nsw", "bmw", "male", 2000).premium).to eq('55.54')
    end
  end

end