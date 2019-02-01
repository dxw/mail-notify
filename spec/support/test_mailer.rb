# frozen_string_literal: true

class TestMailer < Mail::Notify::ViewMailer
  def my_mail
    @foo = 'bar'
    notify_mail('template-id',
                to: 'myemail@gmail.com',
                subject: 'Hello there!')
  end
end
