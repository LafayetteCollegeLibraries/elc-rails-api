json.status '🎃'

json.counts do
  json.authors Author.count
  json.items Item.count
  json.ledgers Ledger.count
  json.loans Loan.count
  json.patrons Patron.count
  json.subjects Subject.count
end