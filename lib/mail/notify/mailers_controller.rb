# frozen_string_literal: true

module Mail
  module Notify
    module MailersController
      def preview

        # this methods overides the built in one
        # https://www.rubydoc.info/docs/rails/Rails/MailersController#preview-instance_method
        #
        # what kind of mailer is trying to be previewed
        # if it is a Notify one, we need to do something different
        @email_action = File.basename(params[:path])
        @email = @preview.call(@email_action, params)

        if @email.delivery_method.is_a?(Mail::Notify::DeliveryMethod)
          # because we have two types, a view or template, we have to do different
          # things
          debugger
          response.content_type = "text/html"
          debugger
          @part = @email.find_first_mime_type(:html)
        render action: "email", layout: false, formats: %i[html]
        else
          super
        end
      end

      private

      def render_part
        # Add the current directory to the view path so that Rails can find
        # the `govuk_notify_layout` layout
        append_view_path(__dir__)

      end

      def render_preview_wrapper
        @part = @email
        render action: "email", layout: false, formats: %i[html]
      end

      def notify?
        @email.delivery_method.instance_of?(Mail::Notify::DeliveryMethod)
      end
    end
  end
end
