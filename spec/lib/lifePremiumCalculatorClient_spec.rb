require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../pact_helper'
require 'lifePremiumCalculatorClient'

set :environment, :test

describe LifePremiumCalculatorClient, :pact => true do

  $calculator_service_url = "http://localhost:9000"
  carCalcClient = LifePremiumCalculatorClient.new($calculator_service_url)

  describe "life_premium" do

    it "returns right premium for SOAP/XML request" do
      calculator_service.given("LifePremiumRequest").
        upon_receiving("a request for a life premium").
        with(method: :post, path: '/calculator_service', body: "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cal=\"http://www.hans.com/calculator\">\n     <soapenv:Header/>\n     <soapenv:Body>\n        <cal:LifePremiumRequest>\n           <cal:age>23</cal:age>\n           <cal:gender>male</cal:gender>\n           <cal:state>nsw</cal:state>\n           <cal:occupationCategory>risk0</cal:occupationCategory>\n        </cal:LifePremiumRequest>\n     </soapenv:Body>\n  </soapenv:Envelope>").
        will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'text/xml;charset=utf-8'},
          body: "<SOAP:Envelope xmlns:SOAP=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:calculator=\"http://www.hans.com/calculator\">
  <SOAP:Body>
    <calculator:LifePremiumResponse>
      <calculator:LifePremium>47.95</calculator:LifePremium>
    </calculator:LifePremiumResponse>
  </SOAP:Body>
</SOAP:Envelope>\n" )

      expect(LifeQuote.new(23, "hans@tw.com", "nsw", "risk0", "male", true).premium).to eq('47.95')

    end


    it "returns right premium for JSON request" do
      
      calculator_service.given("LifePremiumRequest").
        upon_receiving("a JSON request for a life premium").
        with(method: :get, path: '/life_premium', query: 'age=23&gender=male&occupationCategory=risk0&state=nsw')
        .will_respond_with(
        	status: 200,
        	headers: {"Content-Type" => "application/json"},
        	body: {
        		price: 47.95
        	}
      )
    
      expect(LifeQuote.new(23, "hans@tw.com", "nsw", "risk0", "male").premium).to eq('47.95')
    end
  end

end