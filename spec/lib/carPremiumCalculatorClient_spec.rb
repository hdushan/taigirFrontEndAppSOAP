require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../pact_helper'
require 'carPremiumCalculatorClient'

set :environment, :test

describe CarPremiumCalculatorClient, :pact => true do

  c = CarPremiumCalculatorClient.new
  
  before do
    c.wsdl_url = 'http://localhost:9000'
  end

  # describe "car_premium" do
  #
  #   before do
  #     calculator_service.given("CarPremiumRequest").
  #       upon_receiving("a request for a car premium").
  #       with(method: :post, path: '/calculator_service', query: '').
  #       will_respond_with(
  #         status: 200,
  #         headers: {'Content-Type' => 'text/xml'},
  #         body: {name: 'Betty'} )
  #   end

    it "returns right premium" do
      expect(c.getPremiumForQuote(CarQuote.new(23, "hans@tw.com", "nsw", "bmw", "male", 2000))).to eq('55.54')
    end

end