require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  test "an item may contain an author" do
    item = items(:lunch_poems)
    assert item.author.present?
    assert_equal "O'Hara, Frank", item.author.name
    assert item.author.is_a? Author
  end

  test "an item may sometimes not contain an author" do
    item = items(:no_author_assigned)
    assert item.author.blank?
  end

  test "an item may have subjects" do
    item = items(:frankenstein)
    assert item.subjects.present?
    assert item.subjects.first.is_a? Subject
  end

  test "an item may have multiple subjects" do
    item = items(:lunch_poems)
    assert item.subjects.present?
    assert item.subjects.length > 1
  end

  test "an item may have no subjects" do
    item = Item.new(title: "No Subjects: the True Story")
    assert item.subjects.empty?
  end
end
