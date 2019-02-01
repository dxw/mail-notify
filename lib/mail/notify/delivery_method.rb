# frozen_string_literal: true

module Mail
  module Notify
    class DeliveryMethod
      attr_accessor :settings

      def initialize(settings)
        @settings = settings
      end

      def deliver!(mail)
        @mail = mail
        @personalisation = Personalisation.new(@mail)
        initialize_params
        send_email
      end

      private

      def client
        @client ||= Notifications::Client.new(@settings[:api_key])
      end

      def initialize_params
        @email_params = {
          email_address: @mail.to.first,
          template_id: @mail[:template_id].to_s,
          personalisation: @personalisation.to_h
        }
      end

      def send_email
        client.send_email(@email_params)
      end
    end
  end
end
