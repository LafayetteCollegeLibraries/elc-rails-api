require 'test_helper'

class PatronTest < ActiveSupport::TestCase
  test "`loans` returns all loans (as representative + shareholder)" do
    laurie = patrons(:laurie_strode)
    assert_equal Loan.count, laurie.loans.count
  end

  test "`patron.representative?`" do
    assert patrons(:laurie_strode).representative?
    assert patrons(:tommy_doyle).representative?
  end

  test "`patron.shareholder?`" do
    assert patrons(:laurie_strode).shareholder?
    assert_not patrons(:tommy_doyle).shareholder?
  end

  test "`patron.types` returns an array of labels" do
    laurie = patrons(:laurie_strode)

    assert laurie.types.is_a? Array

    laurie.types.map {|t| assert t.is_a? String }
  end
end
