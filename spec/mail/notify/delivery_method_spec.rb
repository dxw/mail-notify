# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mail::Notify::DeliveryMethod do
  before do
    ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
    ActionMailer::Base.delivery_method = :notify
    ActionMailer::Base.notify_settings = {
      api_key: api_key
    }
  end

  let(:api_key) do
    'staging-e1f4c969-b675-4a0d-a14d-623e7c2d3fd8-24fea27b-824e-4259-b5ce-1badafe98150'
  end
  let(:notify) { double(:notify) }
  let(:preview) { double(Notifications::Client::TemplatePreview) }
  let(:mailer) { TestMailer.my_mail }
  let(:personalisation) { {} }
  let(:request_body) do
    {
      email_address: 'myemail@gmail.com',
      template_id: 'template-id',
      personalisation: personalisation
    }
  end

  let!(:stub) do
    stub_request(:post, 'https://api.notifications.service.gov.uk/v2/notifications/email')
      .with(body: request_body)
      .to_return(body: {
        id: 'aceed36e-6aee-494c-a09f-88b68904bad6'
      }.to_json)
  end

  context 'when API key is blank' do
    let(:api_key) { '' }

    it 'raises an error' do
      expect { mailer.deliver! }.to raise_error(
        ArgumentError,
        'You must specify an API key'
      )
    end
  end

  context 'with a view' do
    let(:personalisation) do
      {
        body: "# bar\r\n\r\nBar baz",
        subject: 'Hello there!'
      }
    end

    it 'has access to the settings' do
      expect(mailer.delivery_method.settings[:api_key]).to eq(api_key)
    end

    it 'calls Notify\'s send_email service with the correct details ' do
      mailer.deliver!

      expect(stub).to have_been_requested
    end

    it 'gives access to the response' do
      mailer.deliver!

      expect(mailer.delivery_method.response.id).to eq(
        'aceed36e-6aee-494c-a09f-88b68904bad6'
      )
    end

    it 'shows a preview' do
      preview_stub = stub_request(:post, 'https://api.notifications.service.gov.uk/v2/template/template-id/preview')
                     .to_return(status: 200, body: {}.to_json)

      mailer.preview

      expect(preview_stub).to have_been_requested
    end
  end

  context 'with a template' do
    let(:personalisation) do
      {
        foo: 'bar'
      }
    end
    let(:mailer) { TestMailer.my_other_mail }

    it 'has access to the settings' do
      expect(mailer.delivery_method.settings[:api_key]).to eq(api_key)
    end

    it 'calls Notify\'s send_email service with the correct details ' do
      mailer.deliver!

      expect(stub).to have_been_requested
    end

    it 'gives access to the response' do
      mailer.deliver!

      expect(mailer.delivery_method.response.id).to eq(
        'aceed36e-6aee-494c-a09f-88b68904bad6'
      )
    end

    it 'shows a preview' do
      preview_stub = stub_request(:post, 'https://api.notifications.service.gov.uk/v2/template/template-id/preview')
                     .to_return(status: 200, body: {}.to_json)

      mailer.preview

      expect(preview_stub).to have_been_requested
    end
  end

  context 'with optional fields included' do
    let(:mailer) { TestMailer.my_mail_optional_fields }
    let(:request_body) do
      hash_including(
        email_reply_to_id: 'custom-reply-to-id',
        reference: 'ABC123XYZ'
      )
    end

    it 'calls Notify’s send_email service with the optional fields' do
      mailer.deliver!

      expect(stub).to have_been_requested
    end
  end

  context 'when a base url is specified' do
    before do
      ActionMailer::Base.notify_settings = {
        api_key: api_key,
        base_url: 'http://example.com'
      }
    end

    let(:personalisation) do
      {
        body: "# bar\r\n\r\nBar baz",
        subject: 'Hello there!'
      }
    end

    let!(:stub) do
      stub_request(:post, 'http://example.com/v2/notifications/email')
        .with(body: request_body)
        .to_return(body: {
          id: 'aceed36e-6aee-494c-a09f-88b68904bad6'
        }.to_json)
    end

    it 'calls appends the new base url to the request' do
      mailer.deliver!

      expect(stub).to have_been_requested
    end
  end
end
