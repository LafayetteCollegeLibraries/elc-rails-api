require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "an item contains a parent work" do
    item = items(:frankenstein)
    work = works(:frankenstein)
    
    assert item.respond_to? :work
    assert_equal work, item.work
  end

  test "a item responds with its work's properties" do
    item = items(:lunch_poems)
    work = works(:lunch_poems)

    assert_equal item.title, work.title
    assert_equal item.full_title, work.full_title
    assert_equal item.author, work.author
    assert_equal item.subjects, work.subjects
  end

  test "an item has associated loans" do
    assert_not items(:lunch_poems).loans.empty?
  end
end