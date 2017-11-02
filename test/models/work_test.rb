require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  test "a work may contain an author" do
    work = works(:lunch_poems)
    author = authors(:frank_o_hara)
    assert work.author.present?
    assert_equal author, work.author
    assert work.author.is_a? Author
  end

  test "a work may sometimes not contain an author" do
    work = works(:no_author_assigned)
    assert work.author.blank?
  end

  test "a work may have subjects" do
    work = works(:frankenstein)

    assert work.respond_to? :subjects
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

  test "a work has loans via its items" do
    work = works(:scary_stories)
    item_1 = items(:scary_stories_1)
    item_2 = items(:scary_stories_2)

    expected_loans = item_1.loans + item_2.loans
    assert_equal expected_loans, work.loans
  end
end
