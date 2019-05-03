# frozen_string_literal: true

require 'notifications/client'

require 'mail/notify/version'
require 'mail/notify/railtie' if defined? Rails
require 'mail/notify/delivery_method'
require 'mail/notify/personalisation'
require 'mail/notify/mailer'
require 'mail/notify/message'

Mail::Message.include Mail::Notify::Message

module Mail
  module Notify
  end
end
