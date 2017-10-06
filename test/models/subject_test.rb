require 'test_helper'

class SubjectTest < ActiveSupport::TestCase
  test "it works i guess" do
    subject = subjects(:fiction)
    assert subject.label.include? "Fiction"
  end
end
