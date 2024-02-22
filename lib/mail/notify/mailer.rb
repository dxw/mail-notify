# frozen_string_literal: true

module Mail
  module Notify
    ##
    # The Mail Notify base Mailer class, overridden in Rails applications to provide the additional
    # Notify behaviour along with the application behaviour.

    class Mailer < ActionMailer::Base
      ##
      # Set a default from address, will only be used in previews if a from address is not supplied
      # by subclasses

      default from: "preview@notifications.service.gov.uk"

      ##
      # Send an email where the content is managed in the Notify template.
      #
      # The required arguments are:
      #
      # - template_id
      # - to address
      #
      # Can include personalisation.
      #
      # Add any additional headers in the options hash.
      #
      # A default subject is supplied as ActionMailer requires one, however it will never be used as
      # the subject is assumed to be managed in the Notify template.

      def template_mail(template_id, options)
        raise ArgumentError, "You must specify a Notify template ID" if template_id.blank?
        raise ArgumentError, "You must specify a to address" if options[:to].nil? || options[:to].blank?

        message.template_id = template_id
        message.reply_to_id = options[:reply_to_id]
        message.reference = options[:reference]

        message.personalisation = options[:personalisation] || {}

        headers = options.except([:personalisation, :reply_to_id, :reference])

        headers[:subject] = "Subject managed in Notify" unless options[:subject]

        # We have to set the html and the plain text content to nil to prevent Rails from looking
        # for the content in the views. We replace nil with the content returned from Notify before
        # sending or previewing
        mail(headers) do |format|
          format.text { nil }
          format.html { nil }
        end
      end

      ##
      # Send an email where the content is managed in the Rails application.
      #
      # The required arguments are:
      #
      # - template_id
      # - to address
      # - subject
      #
      # Personalisation will dropped as all content comes from the view provided by Rails.
      #
      # Add any additional headers in the options hash.

      def view_mail(template_id, options)
        raise ArgumentError, "You must specify a Notify template ID" if template_id.blank?
        raise ArgumentError, "You must supply a to address" if options[:to].blank?
        raise ArgumentError, "You must specify a subject" if options[:subject].blank?

        message.template_id = template_id
        message.reply_to_id = options[:reply_to_id]
        message.reference = options[:reference]

        subject = options[:subject]
        headers = options.except([:personalisation, :reply_to_id, :reference])

        # we have to render the view for the message and grab the raw source, then we set that as the
        # body in the personalisation for sending to the Notify API.
        body = mail(headers).body.raw_source

        # The 'view mail' works by sending a subject and body as personalisation options, these are
        # then used in the Notify template to provide content.
        message.personalisation = {subject: subject, body: body}

        mail(headers) do |format|
          format.text { nil }
          format.html { nil }
        end
      end

      ##
      # allows blank personalisation options

      def blank_allowed(value)
        value.presence || Personalisation::BLANK
      end
    end
  end
end
