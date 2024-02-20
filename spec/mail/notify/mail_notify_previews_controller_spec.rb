# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailNotifyPreviewsController do
  it "can provide a renderer for use in the preview interceptor" do
    expect(described_class.renderer).to be_truthy
  end

  it "can render html to the notify layout" do
    renderer = described_class.renderer

    render_html = "<p>Test render html</p>".html_safe

    rendered_output = renderer.render html: render_html, layout: "govuk_notify_layout"

    expect(rendered_output).to include "Test render html"
    expect(rendered_output).to include "GOV.UK"
  end
end
