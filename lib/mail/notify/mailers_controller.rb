# frozen_string_literal: true

module Mail
  module Notify
    module MailersController
      def preview
        @email_action = File.basename(params[:path])
        return super unless @preview.email_exists?(@email_action)

        @email = @preview.call(@email_action, params)

        return super unless notify?

        return render_part if params[:part]

        render_preview_wrapper
      end

      private

      def render_part
        response.content_type = 'text/html'
        render plain: @email.preview.html.html_safe
      end

      def render_preview_wrapper
        @part = @email
        render action: 'email', layout: false, formats: %w[html]
      end

      def notify?
        @email.delivery_method.class == Mail::Notify::DeliveryMethod
      end
    end
  end
end
