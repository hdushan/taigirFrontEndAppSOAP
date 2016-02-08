require 'sinatra'
require 'haml'
require 'v8'
require 'json'
require 'coffee-script'
require 'carQuote'
require 'lifeQuote'
require 'carPremiumCalculatorClient'
require 'lifePremiumCalculatorClient'
require 'emailValidator'
require 'logger'
require 'savon'



class App < Sinatra::Base
  
  $logger = Logger.new(STDERR)
  emailValidator = EmailValidator.new()
  
  use Rack::Session::Cookie, :key => 'rack.session',
                               :path => '/',
                               :secret => 'secret_stuff'
                               
  $calculator_service_url = "https://taigircalculatorservicesoap.herokuapp.com"

  get '/' do
    session["quote"] ||= nil
    haml :index
  end
  
  get "/bad" do
    content_type :json
    { :login_successful => "false" }.to_json
  end
  
  get "/good" do
    content_type :json
    { :login_successful => "true", :name => "Hans"}.to_json
  end

  get '/life' do
    haml :life
  end
  
  get '/car' do
    haml :car
  end
  
  get '/payment' do
    @quote = session["quote"]
    haml :payment
  end
  
  post '/pay' do
    @quote = session["quote"]
    haml :done
  end
  
  post '/quote' do
    type = params["typeOfInsurance"]
    if type == "life"
      @quote = getLifeQuote(params)
    else
      @quote = getCarQuote(params)
    end
    session["quote"] = @quote
    haml :quote
  end
  
  post '/checkemail' do
    email = params["email"]
    content_type :json
    {:valid => emailValidator.isEmailValid?(email)}.to_json
  end
  
  get '/javascripts/application.js' do
    coffee :application
  end
  
  not_found do
    haml :not_found
  end
  
  def getLifeQuote(params)
    age = params["age"]
    email = params["email"]
    occupationCategory = params["occupation"]
    gender = params["gender"]
    state = params["state"]
    LifeQuote.new(age, email, state, occupationCategory, gender)
  end
  
  def getCarQuote(params)
    age = params["age"]
    email = params["email"]
    make = params["make"]
    year = params["year"]
    gender = params["gender"]
    state = params["state"]
    CarQuote.new(age, email, state, make, gender, year)
  end
  
end