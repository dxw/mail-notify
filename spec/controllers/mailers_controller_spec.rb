# frozen_string_literal: true

require "rails_helper"

RSpec.describe Rails::MailersController, type: :controller do
  render_views

  let(:notify) { double(:notify) }
  let(:preview) { double(Notifications::Client::TemplatePreview) }

  before do
    allow(Notifications::Client).to receive(:new).with("some-api-key", nil) { notify }
    allow(notify).to receive(:generate_template_preview).with(
      "template-id",
      personalisation: {
        body: "bar\r\n\\\r\n* This\r\n* Is\r\n* A\r\n* List",
        subject: "Hello there!"
      }
    ) { preview }
    allow(preview).to receive(:html) { "<p>Some HTML</p>" }
  end

  context "with part specified" do
    it "gets the HTML preview" do
      get :preview, params: {path: "welcome/my_mail", part: "text/html"}

      expect(response.body).to include("<p>Some HTML</p>")
    end

    it "returns a HTML content type" do
      get :preview, params: {path: "welcome/my_mail", part: "text/html"}

      expect(response.media_type).to eq("text/html")
    end
  end

  context "without part specified" do
    it "returns an iframe" do
      get :preview, params: {path: "welcome/my_mail"}

      expect(response.body).to include(
        "<iframe name=\"messageBody\" src=\"?part=text%2Fhtml\"></iframe>"
      )
    end
  end
end
