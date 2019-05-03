# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mail::Message do
  before do
    ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
    ActionMailer::Base.delivery_method = :notify
    ActionMailer::Base.notify_settings = {
      api_key: 'some-api-key'
    }
  end

  let(:message) { TestMailer.my_mail }

  describe '#preview' do
    it 'calls preview on the delivery method' do
      expect(message.delivery_method).to receive(:preview).with(message)
      message.preview
    end
  end
end
