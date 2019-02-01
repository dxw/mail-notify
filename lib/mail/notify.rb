# frozen_string_literal: true

require 'notifications/client'

require 'mail/notify/version'
require 'mail/notify/railtie' if defined? Rails
require 'mail/notify/delivery_method'
require 'mail/notify/core_mailer'
require 'mail/notify/view_mailer'

module Mail
  module Notify
  end
end
