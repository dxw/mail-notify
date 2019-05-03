# frozen_string_literal: true

class WelcomePreview < ActionMailer::Preview
  def my_mail
    WelcomeMailer.my_mail
  end
end
