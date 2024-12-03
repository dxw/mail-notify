# frozen_string_literal: true

module Mail
  module Notify
    module Message
      attr_accessor :template_id, :personalisation, :reply_to_id, :reference, :one_click_unsubscribe_url
    end
  end
end
