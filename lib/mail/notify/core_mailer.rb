module Mail
  module Notify
    class CoreMailer < ActionMailer::Base
      def notify_mail(template_id, headers, &block)
        mail(headers.merge(template_id: template_id), &block)
      end
    end
  end
end