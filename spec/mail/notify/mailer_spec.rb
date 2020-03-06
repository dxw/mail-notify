# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mail::Notify::Mailer do
  let(:mailer) { Mail::Notify::Mailer.new }

  context "with a view" do
    it "sends the template" do
      expect(mailer).to receive(:mail).with(template_id: "foo", bar: "baz")
      mailer.view_mail("foo", bar: "baz")
    end

    it "raises an error if the template ID is blank" do
      expect { mailer.view_mail("", bar: "baz") }.to raise_error(
        ArgumentError,
        "You must specify a template ID"
      )
    end
  end

  context "with a template" do
    it "sends a blank body and subject" do
      expect(mailer).to receive(:mail).with(
        template_id: "foo",
        bar: "baz",
        body: "",
        subject: ""
      )
      mailer.template_mail("foo", bar: "baz")
    end

    it "raises an error if the template ID is blank" do
      expect { mailer.template_mail("", bar: "baz") }.to raise_error(
        ArgumentError,
        "You must specify a template ID"
      )
    end
  end
end
