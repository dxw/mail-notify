# frozen_string_literal: true

##
# This is a ActionMailer interceptor class for previews from the Notifications API
#
# See ActionMailer::Base:
#
# https://github.com/rails/rails/blob/v5.2.8.1/actionmailer/lib/action_mailer/base.rb#L367

class MailNotifyPreviewInterceptor
  ##
  # ActionMailer call back when a preview is being generated.
  #
  # Transforms the content of the passed in message.

  def self.previewing_email(message)
    new(message).transform!
  end

  ##
  # Creates a new MailNotifyPreviewInterceptor ready for use.

  def initialize(message)
    @message = message
  end

  ##
  # Transforms the content of the message to that from the Notifications API preview.
  #
  # The html is wrapped in a layout and rendered by the MailNotifyPreviewsControllers renderer.

  def transform!
    # the messages delivery method will be our Mail::Notify::DeliveryMethod and have the `preview` method.
    preview = @message.delivery_method.preview(@message)

    @message.subject = preview.subject
    @message.html_part.body = renderer.render html: preview.html.html_safe, layout: "govuk_notify_layout"
    @message.text_part.body = preview.body

    @message
  end

  private

  def renderer
    # rendering in Rails without a controller gets far too complicated, instead
    # we rely on this empty controller to do it for us.

    MailNotifyPreviewsController.renderer
  end
end
