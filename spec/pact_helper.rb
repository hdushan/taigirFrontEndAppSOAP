require 'pact'
require 'pact/consumer/rspec'
require 'pact/xml'

Pact.configure do | config |
    config.register_body_differ /xml/, Pact::XML::Differ
    config.register_diff_formatter /xml/, Pact::XML::DiffFormatter
end

Pact.service_consumer "Quote Front End app" do
  has_pact_with "Calculator Service" do
    mock_service :calculator_service do
      port 9000
    end
  end
end