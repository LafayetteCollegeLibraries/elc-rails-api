require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  test "a work may contain an author" do
    work = works(:lunch_poems)
    assert work.author.present?
    assert_equal "O'Hara, Frank", work.author.name
    assert work.author.is_a? Author
  end

  test "a work may sometimes not contain an author" do
    work = works(:no_author_assigned)
    assert work.author.blank?
  end

  test "a work may have subjects" do
    work = works(:frankenstein)
    assert work.subjects.present?
    assert work.subjects.first.is_a? Subject
  end

  test "a work may have multiple subjects" do
    work = works(:lunch_poems)
    assert work.subjects.present?
    assert work.subjects.length > 1
  end

  test "a work may have no subjects" do
    work = Work.new(title: "No Subjects: the True Story")
    assert work.subjects.empty?
  end
end
