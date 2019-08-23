# frozen_string_literal: true

class TestMailer < Mail::Notify::Mailer
  def my_mail
    @foo = 'bar'
    view_mail('template-id',
              to: 'myemail@gmail.com',
              subject: 'Hello there!')
  end

  def my_other_mail
    template_mail('template-id',
                  to: 'myemail@gmail.com',
                  personalisation: {
                    foo: 'bar'
                  })
  end

  def my_mail_custom_reply_to
    view_mail('template-id',
      to: 'email@gmail.com',
      subject: 'Hello there!',
      reply_to_id: 'custom-reply-to-id')
  end
end
