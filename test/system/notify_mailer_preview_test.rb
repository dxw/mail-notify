require "test_helper"

class NotifyMailerPreviewTest < ActionDispatch::SystemTestCase
  # User rack_test not a browser
  driven_by :rack_test

  # Template email previews
  test "previews the template email headers" do
    visit "/rails/mailers/notify_mailer/template_email"

    assert_content "Template email subject"
    assert_content "template.email@notifications.service.gov.uk"
  end

  test "previews the template email html body" do
    visit "/rails/mailers/notify_mailer/template_email?part=text%2Fhtml"

    assert_content "Template email message."
  end

  test "previews the template email plain text body" do
    visit "/rails/mailers/notify_mailer/template_email?part=text%2Fplain"

    assert_content "Template email message."
  end

  # Template email previews with personalisation
  test "previews the template email headers with personalisation" do
    visit "/rails/mailers/notify_mailer/template_email_with_personalisation"

    assert_content "Template email subject"
    assert_content "template.email@notifications.service.gov.uk"
  end

  test "previews the template email html body with personalisation" do
    visit "/rails/mailers/notify_mailer/template_email_with_personalisation?part=text%2Fhtml"

    assert_content "Dear Test Name"
    assert_content "Template email message."
  end

  test "previews the template email plain text body with personalisation" do
    visit "/rails/mailers/notify_mailer/template_email_with_personalisation?part=text%2Fplain"

    assert_content "Dear Test Name"
    assert_content "Template email message."
  end

  # View email previews
  test "previews the view email headers" do
    visit "/rails/mailers/notify_mailer/view_email"

    assert_content "View email subject"
    assert_content "view.email@notifications.service.gov.uk"
  end

  test "previews the view email html body" do
    visit "/rails/mailers/notify_mailer/view_email?part=text%2Fhtml"

    assert_content "View email message"
  end

  test "previews the view email plain text" do
    visit "/rails/mailers/notify_mailer/view_email?part=text%2Fhtml"

    assert_content "View email message"
  end
end
