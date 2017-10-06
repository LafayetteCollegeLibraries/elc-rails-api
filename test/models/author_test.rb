require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test "has a name" do
    author = authors(:frank_o_hara)
    assert author.name.present?
    assert_not author.name.nil?
    assert_equal "O'Hara, Frank", author.name
  end
end
