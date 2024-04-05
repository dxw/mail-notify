require "test_helper"

class NotifyMailerSendingTest < ActionDispatch::IntegrationTest
  # these tests are designed to run in our integration environment and make real
  # requests to Notify, the API key we use WILL NOT actually send any email.
  #
  # Once this spec runs, you will see these email in the Notify 'API Integrations'
  # log which requires an login for our integration test Notify account and only
  # remain for 7 days.
  #
  test "can send a template email" do
    result = NotifyMailer.with(
      to: "template.email@notifications.service.gov.uk"
    ).template_email.deliver_now

    assert result.instance_of? Mail::Message
  end

  test "can send a template email with personalisation" do
    result = NotifyMailer.with(
      to: "template.email@notifications.service.gov.uk",
      name: "Test Name"
    ).template_with_personalisation.deliver_now

    assert result.instance_of? Mail::Message
  end

  test "can send a view email" do
    result = NotifyMailer.with(
      to: "view.email@notifications.service.gov.uk",
      subject: "View email subject"
    ).view_email.deliver_now

    assert result.instance_of? Mail::Message
  end
end
