require 'spec_helper'

RSpec.describe Mail::Notify::DeliveryMethod do
  before do
    ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
    ActionMailer::Base.delivery_method = :notify
    ActionMailer::Base.notify_settings = {
      api_key: 'some-api-key'
    }
  end

  let(:mailer) { TestMailer.my_mail }

  it 'has access to the settings' do
    expect(mailer.delivery_method.settings[:api_key]).to eq('some-api-key')
  end

  it 'calls Notify\'s send_email service with the correct details ' do
    notify = double(:notify)
    expect(Notifications::Client).to receive(:new).with('some-api-key') { notify }
    expect(notify).to receive(:send_email).with({
      email_address: 'myemail@gmail.com',
      template_id: 'template-id',
      personalisation: {
        body: "# bar\r\n\r\nBar baz",
        subject: 'Hello there!'
      }
    })
    TestMailer.my_mail.deliver!
  end
end
