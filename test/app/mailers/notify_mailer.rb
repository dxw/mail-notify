class NotifyMailer < Mail::Notify::Mailer
  def view_email
    subject = params[:subject]
    to = params[:to]

    view_mail("8153737e-7f6c-4a6f-b33c-48d954e07257", {to: to, subject: subject})
  end

  def template_email
    to = params[:to]

    template_mail("46bec5ff-354c-4a98-8c91-277bc5d4e09b", to: to)
  end

  def template_with_personalisation
    name = params[:name]
    to = params[:email_address]

    template_mail("5c9f8048-4283-40f8-9694-7dbb86b1f636", to: to, personalisation: {name: name})
  end
end
