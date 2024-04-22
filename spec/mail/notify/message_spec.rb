# frozen_string_literal: true

require "spec_helper"

class FakeTestClass
  include Mail::Notify::Message
end

RSpec.describe Mail::Notify::Message do
  subject { FakeTestClass.new }

  it "adds a template_id attribute" do
    expect(subject.template_id = "template-id").to eql "template-id"
    expect(subject.template_id).to eql "template-id"
  end

  it "adds a personalisation attribute" do
    expect(subject.personalisation = {name: "Test Name"}).to eql({name: "Test Name"})
    expect(subject.personalisation).to eql({name: "Test Name"})
  end

  it "adds the reply_to_id attribute" do
    expect(subject.reply_to_id = "test-reply-to-id").to eql("test-reply-to-id")
    expect(subject.reply_to_id).to eql("test-reply-to-id")
  end

  it "adds the reference attribute" do
    expect(subject.reference = "test-reference").to eql("test-reference")
    expect(subject.reference).to eql("test-reference")
  end
end
