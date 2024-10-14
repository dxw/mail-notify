# frozen_string_literal: true

require "spec_helper"
require "mailers/test_mailer"

RSpec.describe Mail::Notify::Mailer do
  describe "#view_mail" do
    it "sets the message template id" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.template_id).to eql("template-id")
    end

    it "sets a custom value as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", custom_header: "custom"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:custom_header]).to be_a(Mail::Field)
      expect(message.header[:custom_header].value).to eq('custom')
    end

    it "does not set reply_to_id as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", reply_to_id: "123"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:reply_to_id]).to be_nil
    end

    it "does not set reference as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", reference: "ref-123"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:reference]).to be_nil
    end

    it "does not set personalisation as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", personalisation: "Dear sir"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:personalisation]).to be_nil
    end

    it "sets the message subject" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:subject]).to be_a Mail::Field
      expect(message.header[:subject].value).to eql("Test subject")
    end

    it "sets the message to address" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.header[:to]).to be_a Mail::Field
      expect(message.header[:to].value).to eql("test.name@email.co.uk")
    end

    it "sets the subject on personalisation" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.personalisation[:subject]).to eql("Test subject")
    end

    it "sets the body on personalisation" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect(message.personalisation[:body]).to eql("This is the body from the mailers view.\r\n")
    end

    it "drops any further personalisation" do
      message_params = {
        template_id: "template-id",
        to: "test.name@email.co.uk",
        subject: "Test subject",
        personalisation: {name: "Test Name"}
      }

      message = TestMailer.with(message_params).test_view_mail

      expect(message.personalisation.key?(:name)).to be false
    end

    it "sets the reply_to_id" do
      message_params = {
        template_id: "template-id",
        to: "test.name@email.co.uk",
        subject: "Test subject",
        reply_to_id: "test-reply-to-id"
      }

      message = TestMailer.with(message_params).test_view_mail

      expect(message.reply_to_id).to eql("test-reply-to-id")
    end

    it "sets the reference" do
      message_params = {
        template_id: "template-id",
        to: "test.name@email.co.uk",
        subject: "Test subject",
        reference: "test-reference"
      }

      message = TestMailer.with(message_params).test_view_mail

      expect(message.reference).to eql("test-reference")
    end

    it "requires template id to be set" do
      message_params = {to: "test.name@email.co.uk", subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect { message.template_id }.to raise_error(
        ArgumentError, "You must specify a Notify template ID"
      )
    end

    it "requires to address to be set" do
      message_params = {template_id: "template-id", subject: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect { message.header[:to] }.to raise_error(
        ArgumentError, "You must supply a to address"
      )
    end

    it "requires subject to be set" do
      message_params = {template_id: "template-id", to: "Test subject"}

      message = TestMailer.with(message_params).test_view_mail

      expect { message.header[:subject] }.to raise_error(
        ArgumentError, "You must specify a subject"
      )
    end
  end

  describe "#template_email" do
    it "sets the message template id" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.template_id).to eql("template-id")
    end

    it "does not set reply_to_id as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", reply_to_id: "123"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:reply_to_id]).to be_nil
    end

    it "does not set reference as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", reference: "ref-123"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:reference]).to be_nil
    end

    it "does not set personalisation as a header" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "Test subject", personalisation: "Dear sir"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:personalisation]).to be_nil
    end

    it "sets the message to address" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:to]).to be_a Mail::Field
      expect(message.header[:to].value).to eql("test.name@email.co.uk")
    end

    it "sets the subject as ActionMailer requires one" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:subject]).to be_a Mail::Field
      expect(message.header[:subject].value).to eql("Subject managed in Notify")
    end

    it "sets the subject if one is passed, even though it will not be used" do
      message_params = {template_id: "template-id", to: "test.name@email.co.uk",
                        subject: "My subject"}

      message = TestMailer.with(message_params).test_template_mail

      expect(message.header[:subject]).to be_a Mail::Field
      expect(message.header[:subject].value).to eql("My subject")
    end

    context "without personalisation" do
      it "sets the personalisation of the message to an empty hash" do
        message_params = {template_id: "template-id", to: "test.name@email.co.uk"}

        message = TestMailer.with(message_params).test_template_mail

        expect(message.personalisation).to eql({})
      end
    end

    context "with personalisation" do
      it "sets the personalisation of the message" do
        message_params = {
          template_id: "template-id",
          to: "test.name@email.co.uk",
          personalisation: {name: "Name", age: "25"}
        }

        message = TestMailer.with(message_params).test_template_mail

        expect(message.personalisation).to eql({name: "Name", age: "25"})
      end
    end

    it "sets the reply_to_id" do
      message_params = {
        template_id: "template-id",
        to: "test.name@email.co.uk",
        subject: "Test subject",
        reply_to_id: "test-reply-to-id"
      }

      message = TestMailer.with(message_params).test_template_mail

      expect(message.reply_to_id).to eql("test-reply-to-id")
    end

    it "sets the reference" do
      message_params = {
        template_id: "template-id",
        to: "test.name@email.co.uk",
        subject: "Test subject",
        reference: "test-reference"
      }

      message = TestMailer.with(message_params).test_template_mail

      expect(message.reference).to eql("test-reference")
    end
  end

  describe "#blank_allowed" do
    context "when given a non-blank value" do
      it "returns the given value" do
        expect(TestMailer.new.blank_allowed("foo")).to eq "foo"
      end
    end

    context "when given an empty string" do
      it "returns explicitly blank personalisation" do
        expect(TestMailer.new.blank_allowed("")).to eq ""
      end
    end

    context "when given nil" do
      it "returns an empty string" do
        expect(TestMailer.new.blank_allowed(nil)).to eq ""
      end
    end
  end
end
