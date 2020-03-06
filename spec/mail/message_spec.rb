# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mail::Message do
  let(:api_key) do
    "staging-e1f4c969-b675-4a0d-a14d-623e7c2d3fd8-24fea27b-824e-4259-b5ce-1badafe98150"
  end

  before do
    ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
    ActionMailer::Base.delivery_method = :notify
    ActionMailer::Base.notify_settings = {
      api_key: api_key
    }
  end

  let(:message) { TestMailer.my_mail }

  describe "#preview" do
    it "calls preview on the delivery method" do
      stub = stub_request(:post, "https://api.notifications.service.gov.uk/v2/template/template-id/preview")
        .to_return(status: 200, body: {}.to_json)

      message.preview

      expect(stub).to have_been_requested
    end
  end
end
