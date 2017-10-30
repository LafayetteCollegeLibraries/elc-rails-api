require 'test_helper'

class LoanTest < ActiveSupport::TestCase
  test "setting `checkout_date` by string converts to DateTime" do
    loan = loans(:scary_stories)

    now = DateTime.new(2017, 10, 9)
    now_string = now.strftime('%m/%d/%Y')

    assert_not_equal now, loan.checkout_date

    loan.checkout_date = now_string

    assert_equal now, loan.checkout_date
  end

  test "setting `return_date` by string converts to DateTime" do
    loan = loans(:scary_stories)

    now = DateTime.new(2017, 10, 9)
    now_string = now.strftime('%m/%d/%Y')

    assert_not_equal now, loan.return_date

    loan.return_date = now_string

    assert_equal now, loan.return_date
  end

  test "`label` returns a descriptive text" do
    loan = loans(:scary_stories)
    assert loan.label.is_a? String

    assert loan.label.include? loan.loaned_to
    assert loan.label.include? loan.work.title
  end

  test "`loaned_to` returns the representative's name if present" do
    loan = loans(:scary_stories)
    tommy = patrons(:tommy_doyle)
    assert_equal tommy.name, loan.loaned_to
  end

  test "`for_patron` returns loans where patron is shareholder or representative" do
    lauries_loans = Loan.for_patron(patrons(:laurie_strode))
    tommys_loans = Loan.for_patron(patrons(:tommy_doyle))

    assert_equal lauries_loans.map(&:id), Loan.all.map(&:id)
    assert tommys_loans.count < Loan.count
  end

  test "`for_representative` returns loans where patron is the representative" do
    laurie = patrons(:laurie_strode)
    tommy = patrons(:tommy_doyle)
    
    lauries_rep_loans = Loan.for_representative(laurie)
    tommys_rep_loans = Loan.for_representative(tommy)
    
    lauries_rep_loans.each { |loan| assert_equal loan.representative, laurie }
    tommys_rep_loans.each { |loan| assert_equal loan.representative, tommy }
  end
end
