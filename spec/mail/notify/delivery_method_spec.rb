# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mail::Notify::DeliveryMethod do
  before do
    ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
    ActionMailer::Base.delivery_method = :notify
    ActionMailer::Base.notify_settings = {
      api_key: 'some-api-key'
    }
  end

  let(:notify) { double(:notify) }
  let(:preview) { double(Notifications::Client::TemplatePreview) }

  context 'with a view' do
    let(:mailer) { TestMailer.my_mail }

    it 'has access to the settings' do
      expect(mailer.delivery_method.settings[:api_key]).to eq('some-api-key')
    end

    it 'calls Notify\'s send_email service with the correct details ' do
      expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      expect(notify).to receive(:send_email).with(
        email_address: 'myemail@gmail.com',
        template_id: 'template-id',
        personalisation: {
          body: "# bar\r\n\r\nBar baz",
          subject: 'Hello there!'
        }
      )
      mailer.deliver!
    end

    it 'gives access to the response' do
      response = double(:response)
      allow(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      allow(notify).to receive(:send_email) { response }
      mailer.deliver!

      expect(mailer.delivery_method.response).to eq(response)
    end

    it 'shows a preview' do
      expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      expect(notify).to receive(:generate_template_preview)
        .with('template-id',
              personalisation: {
                body: "# bar\r\n\r\nBar baz",
                subject: 'Hello there!'
              }) { preview }

      mailer.preview
    end
  end

  context 'with a template' do
    let(:mailer) { TestMailer.my_other_mail }

    it 'has access to the settings' do
      expect(mailer.delivery_method.settings[:api_key]).to eq('some-api-key')
    end

    it 'calls Notify\'s send_email service with the correct details ' do
      expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      expect(notify).to receive(:send_email).with(
        email_address: 'myemail@gmail.com',
        template_id: 'template-id',
        personalisation: {
          foo: 'bar'
        }
      )
      mailer.deliver!
    end

    it 'gives access to the response' do
      response = double(:response)
      allow(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      allow(notify).to receive(:send_email) { response }
      mailer.deliver!

      expect(mailer.delivery_method.response).to eq(response)
    end

    it 'shows a preview' do
      expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      expect(notify).to receive(:generate_template_preview).with('template-id',
                                                                 personalisation: {
                                                                   foo: 'bar'
                                                                 }) { preview }

      mailer.preview
    end
  end

  context 'with optional fields included' do
    let(:mailer) { TestMailer.my_mail_optional_fields }

    it 'calls Notify’s send_email service with the optional fields' do
      expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
      expect(notify).to receive(:send_email).with(
        email_address: 'email@gmail.com',
        template_id: 'template-id',
        email_reply_to_id: 'custom-reply-to-id',
        reference: 'ABC123XYZ',
        personalisation: {
          body: "Foo\r\n",
          subject: 'Hello there!'
        }
      )
      mailer.deliver!
    end
  end
end
