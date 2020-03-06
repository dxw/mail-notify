# frozen_string_literal: true

class WelcomeMailer < Mail::Notify::Mailer
  def my_mail
    @foo = "bar"
    view_mail("template-id",
      to: "myemail@gmail.com",
      subject: "Hello there!")
  end

  def my_other_mail
    template_mail("template-id",
      to: "myemail@gmail.com",
      personalisation: {
        foo: "bar"
      })
  end
end
