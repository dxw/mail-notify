# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailNotifyPreviewInterceptor do
  let(:preview_response_double) do
    double(
      "preview message response",
      subject: "Preview subject",
      html: "<p>Preview body</p>",
      body: "Preview body"
    )
  end

  let(:delivery_method_double) do
    double("delivery method", preview: preview_response_double)
  end

  let(:message_double) do
    message = Mail::Message.new(subject: "Original subject")

    message.add_part(Mail::Part.new(content_type: "text/html"))
    message.add_part(Mail::Part.new(content_type: "text/plain"))

    allow(message).to receive(:delivery_method).and_return(delivery_method_double)
    message
  end

  describe ".previewing_email" do
    it "transforms the message" do
      transformed_message = MailNotifyPreviewInterceptor.previewing_email(message_double)

      expect(transformed_message.subject).to eql("Preview subject")
      expect(transformed_message.text_part.body.raw_source).to eql("Preview body")
      expect(transformed_message.html_part.body).to include("<p>Preview body</p>")
    end
  end

  describe "#transform!" do
    it "sets the subject of the message" do
      message = message_double

      described_class.new(message).transform!

      expect(message.subject).to eql preview_response_double.subject
    end

    it "sets the plain text body  of the message" do
      message = message_double

      described_class.new(message).transform!

      expect(message.text_part.body.raw_source).to eql preview_response_double.body
    end

    it "sets the html body of the message" do
      message = message_double

      described_class.new(message).transform!

      expect(message.html_part.body.raw_source).to include(preview_response_double.html)
    end
  end
end
