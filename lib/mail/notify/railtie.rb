# frozen_string_literal: true

module Mail
  module Notify
    class Railtie < Rails::Railtie
      initializer 'mail-notify.add_delivery_method', before: 'action_mailer.set_configs' do
        ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)
      end
    end
  end
end
