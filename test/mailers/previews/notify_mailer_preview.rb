class NotifyMailerPreview < ActionMailer::Preview
  def view_email
    NotifyMailer.with(to: "view.email@notifications.service.gov.uk", subject: "View email subject").view_email
  end

  def template_email
    NotifyMailer.with(to: "template.email@notifications.service.gov.uk").template_email
  end

  def template_email_with_personalisation
    NotifyMailer.with(to: "template.email@notifications.service.gov.uk", name: "Test Name").template_with_personalisation
  end

  def template_email_with_blank_personalisation
    NotifyMailer.with(to: "template.email@notifications.service.gov.uk", name: nil).template_with_blank_personalisation
  end
end
