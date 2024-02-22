# frozen_string_literal: true

class TestMailer < Mail::Notify::Mailer
  def test_view_mail
    template_id = params[:template_id]
    options = params.except(:template_id)

    view_mail(template_id, options)
  end

  def test_template_mail
    template_id = params[:template_id]
    options = params.except(:template_id)

    template_mail(template_id, options)
  end
end
