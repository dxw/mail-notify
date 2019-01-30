class TestMailer < ActionMailer::Base
  def my_mail
    @foo = 'bar'
    mail(to: 'myemail@gmail.com',
        template_id: 'template-id',
        subject: 'Hello there!')
  end
end