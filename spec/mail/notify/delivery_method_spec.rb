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
  end
end
