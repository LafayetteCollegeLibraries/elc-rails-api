class HomeController < ApplicationController
  def index
    @counts = {
      authors: Author.count,
      items: Item.count,
      ledgers: Ledger.count,
      loans: Loan.count,
      patrons: Patron.count,
      subjects: Subject.count,
      works: Work.count,
    }
  end
end