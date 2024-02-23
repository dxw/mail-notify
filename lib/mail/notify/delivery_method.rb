# frozen_string_literal: true

module Mail
  module Notify
    class DeliveryMethod
      attr_accessor :settings, :response

      def initialize(settings)
        raise ArgumentError, "You must specify a Notify API key" if settings[:api_key].blank?

        @settings = settings
      end

      def deliver!(message)
        params = {
          template_id: message.template_id,
          email_address: message.to.first,
          personalisation: message.personalisation,
          email_reply_to_id: message.reply_to_id,
          reference: message.reference
        }

        client.send_email(params.compact)
      end

      def preview(message)
        template_id = message.template_id
        personalisation = message.personalisation

        Rails.logger.info("Getting Notify preview for template id #{template_id}")
        client.generate_template_preview(template_id, personalisation: personalisation)
      end

      private

      def client
        @client ||= Notifications::Client.new(@settings[:api_key], @settings[:base_url])
      end
    end
  end
end
