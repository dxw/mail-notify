# frozen_string_literal: true

module Mail
  module Notify
    class Mailer < ActionMailer::Base
      def view_mail(template_id, headers)
        mail(headers.merge(template_id: template_id))
      end

      def template_mail(template_id, headers)
        mail(headers.merge(body: '', subject: '', template_id: template_id))
      end
    end
  end
end
