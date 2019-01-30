module Mail
  module Notify
    class DeliveryMethod
      attr_accessor :settings

      def initialize(settings)
        @settings = settings
      end

      def deliver!(mail)
        initialize_params(mail)
        send_email
      end

      private

      def client
        @client ||= Notifications::Client.new(@settings[:api_key])
      end

      def initialize_params(mail)
        @email_params = {
          email_address: mail.to.first,
          template_id: mail[:template_id].to_s,
          personalisation: {
            body: mail.body.raw_source,
            subject: mail.subject
          }
        }
      end

      def send_email
        client.send_email(@email_params)
      end
    end
  end
end