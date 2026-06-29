# frozen_string_literal: true

require "spec_helper"
require "mailers/test_mailer"

RSpec.describe Mail::Notify::DeliveryMethod do
  let!(:mock_notifications_client) do
    notifications_client = double(Notifications::Client)
    allow(notifications_client).to receive(:send_email).and_return(notification_response)
    allow(notifications_client).to receive(:generate_template_preview)
    allow(Notifications::Client).to receive(:new).and_return(notifications_client)
    notifications_client
  end

  let(:notification_response) { double(Notifications::Client::Notification) }

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

  shared_examples "sets and returns notification response" do
    it "returns the notification response" do
      response = message.delivery_method.deliver!(message)

      expect(response).to eq(notification_response)
    end

    it "sets 'response' attribute on the delivery method object" do
      delivery_method = message.delivery_method
      response = delivery_method.deliver!(message)

      expect(delivery_method.response).to eq(notification_response)
    end
  end


  describe "settings" do
    let(:notify) { double(:notify) }
    let(:preview) { double(Notifications::Client::TemplatePreview) }
    let(:message) do
      TestMailer.with(
        template_id: "test-id",
        to: "test.name@email.co.uk"
      ).test_template_mail
    end

    it "provides the API key when one is set" do
      mock_notifications_client
      settings = {api_key: api_key}

      delivery_method = described_class.new(settings)
      delivery_method.deliver!(message)

      expect(Notifications::Client).to have_received(:new).with(api_key, nil)
    end

    it "raises an error when the API key is not set" do
      mock_notifications_client
      settings = {api_key: nil}

      expect { described_class.new(settings) }
        .to raise_error ArgumentError, "You must specify a Notify API key"
    end

    it "provides the base url when one is set" do
      mock_notifications_client
      base_url = "example.com"
      settings = {api_key: api_key, base_url: base_url}

      delivery_method = described_class.new(settings)
      delivery_method.deliver!(message)

      expect(Notifications::Client).to have_received(:new).with(api_key, base_url)
    end
  end

  context "with a template email" do
    context "without any personalisation" do
      let(:message) do
        TestMailer.with(
          template_id: "test-id-without-personalisation",
          to: "test.name@email.co.uk"
        ).test_template_mail
      end

      describe "#deliver!" do
        it "calls the Notifications API with the correct params" do
          notifications_client = mock_notifications_client

          message.delivery_method.deliver!(message)

          expect(notifications_client).to have_received(:send_email).with(
            template_id: "test-id-without-personalisation",
            email_address: "test.name@email.co.uk",
            personalisation: {}
          )
        end

        include_examples "sets and returns notification response"
      end

      describe "#preview" do
        it "calls the Notifications API with the correct params" do
          notifications_client = mock_notifications_client

          message.delivery_method.preview(message)

          expect(notifications_client).to have_received(:generate_template_preview).with(
            "test-id-without-personalisation",
            {personalisation: {}}
          )
        end

        include_examples "sets and returns notification response"
      end
    end

    context "with personalisation" do
      let(:message) {
        TestMailer.with(
          template_id: "test-id-with-personalisation",
          to: "test.name@email.co.uk",
          personalisation: {name: "Name", age: "25"}
        ).test_template_mail
      }

      describe "#deliver!" do
        it "calls the Notifications API with the correct params" do
          notifications_client = mock_notifications_client

          message.delivery_method.deliver!(message)

          expect(notifications_client).to have_received(:send_email).with(
            template_id: "test-id-with-personalisation",
            email_address: "test.name@email.co.uk",
            personalisation: {age: "25", name: "Name"}
          )
        end

        include_examples "sets and returns notification response"
      end

      describe "#preview" do
        it "calls the Notifications API with the correct params" do
          notifications_client = mock_notifications_client

          message.delivery_method.preview(message)

          expect(notifications_client).to have_received(:generate_template_preview).with(
            "test-id-with-personalisation",
            {personalisation: {age: "25", name: "Name"}}
          )
        end

        include_examples "sets and returns notification response"
      end
    end
  end

  context "with a view email" do
    let(:message) {
      TestMailer.with(
        template_id: "test-id-with-a-view",
        to: "test.name@email.co.uk",
        subject: "Another subject"
      ).test_view_mail
    }

    describe "#deliver!" do
      it "calls the Notifications API with the correct params" do
        notifications_client = mock_notifications_client

        message.delivery_method.deliver!(message)

        expect(notifications_client).to have_received(:send_email).with(
          template_id: "test-id-with-a-view",
          email_address: "test.name@email.co.uk",
          personalisation: {subject: "Another subject", body: "This is the body from the mailers view.\r\n"}
        )
      end

      include_examples "sets and returns notification response"
    end

    describe "#preview" do
      it "calls the Notifications API with the correct params" do
        notifications_client = mock_notifications_client

        message.delivery_method.preview(message)

        expect(notifications_client).to have_received(:generate_template_preview).with(
          "test-id-with-a-view",
          {personalisation: {subject: "Another subject", body: "This is the body from the mailers view.\r\n"}}
        )
      end

      include_examples "sets and returns notification response"
    end
  end

  describe "Notify optional fields" do
    context "when no optional fields present" do
      let(:message) do
        TestMailer.with(
          template_id: "test-id",
          to: "test.name@email.co.uk"
        ).test_template_mail
      end

      it "optional fields not present in the call to the Notify API" do
        notifications_client = mock_notifications_client

        message.delivery_method.deliver!(message)

        expect(notifications_client).to have_received(:send_email).with(
          template_id: "test-id",
          email_address: "test.name@email.co.uk",
          personalisation: {}
        )
      end

      include_examples "sets and returns notification response"
    end

    describe "email_reply_to_id" do
      let(:message) do
        TestMailer.with(
          template_id: "test-id",
          to: "test.name@email.co.uk",
          reply_to_id: "test-reply-to-id"
        ).test_template_mail
      end

      it "is present in the API call when set" do
        notifications_client = mock_notifications_client

        message.delivery_method.deliver!(message)

        expect(notifications_client).to have_received(:send_email).with(
          template_id: "test-id",
          email_address: "test.name@email.co.uk",
          personalisation: {},
          email_reply_to_id: "test-reply-to-id"
        )
      end

      include_examples "sets and returns notification response"
    end

    describe "reference" do
      let(:message) do
        TestMailer.with(
          template_id: "test-id",
          to: "test.name@email.co.uk",
          reference: "test-reference"
        ).test_template_mail
      end

      it "is present in the API call when set" do
        notifications_client = mock_notifications_client

        message.delivery_method.deliver!(message)

        expect(notifications_client).to have_received(:send_email).with(
          template_id: "test-id",
          email_address: "test.name@email.co.uk",
          personalisation: {},
          reference: "test-reference"
        )
      end

      include_examples "sets and returns notification response"
    end

    describe "one_click_unsubscribe_url" do
      let(:one_click_unsubscribe_url) { "https://www.example.com/unsubscribe?opaque=123" }
      let(:message) do
        TestMailer.with(
          template_id: "test-id",
          to: "test.name@email.co.uk",
          one_click_unsubscribe_url:
        ).test_template_mail
      end

      it "is present in the API call when set" do
        notifications_client = mock_notifications_client

        message.delivery_method.deliver!(message)

        expect(notifications_client).to have_received(:send_email).with(
          template_id: "test-id",
          email_address: "test.name@email.co.uk",
          personalisation: {},
          one_click_unsubscribe_url:
        )
      end

      include_examples "sets and returns notification response"
    end
  end
end
