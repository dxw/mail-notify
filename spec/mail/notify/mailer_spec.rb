# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mail::Notify::Mailer do
  let(:mailer) { Mail::Notify::Mailer.new }

  context "with a view" do
    it "sends the template" do
      expect(mailer).to receive(:mail).with({template_id: "foo", bar: "baz"})
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
      expect(mailer).to receive(:mail).with({
        template_id: "foo",
        bar: "baz",
        body: "",
        subject: ""
      })
      mailer.template_mail("foo", bar: "baz")
    end

    it "raises an error if the template ID is blank" do
      expect { mailer.template_mail("", bar: "baz") }.to raise_error(
        ArgumentError,
        "You must specify a template ID"
      )
    end
  end

  describe "#blank_allowed" do
    context "when given a non-blank value" do
      it "returns the given value" do
        expect(mailer.blank_allowed("foo")).to eq "foo"
      end
    end

    context "when given a blank value" do
      it "returns explicitly blank personalisation" do
        expect(mailer.blank_allowed("")).to be Mail::Notify::Personalisation::BLANK
      end
    end
  end
end
