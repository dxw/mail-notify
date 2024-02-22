# frozen_string_literal: true

require "notifications/client"

require "mail/notify/version"
require "mail/notify/engine" if defined? Rails
require "mail/notify/delivery_method"
require "mail/notify/personalisation"
require "mail/notify/mailer"
require "mail/notify/message"
require "mail/notify/mail_notify_previews_controller"
require "mail/notify/mail_notify_preview_interceptor"

Mail::Message.include Mail::Notify::Message

module Mail
  module Notify
  end
end
