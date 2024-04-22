# frozen_string_literal: true

module Mail
  module Notify
    class Engine < Rails::Engine
      initializer "mail-notify.add_delivery_method", before: "action_mailer.set_configs" do
        ActionMailer::Base.add_delivery_method(:notify, Mail::Notify::DeliveryMethod)

        config.action_mailer.preview_interceptors = [:mail_notify_preview_interceptor]
      end
    end
  end
end
