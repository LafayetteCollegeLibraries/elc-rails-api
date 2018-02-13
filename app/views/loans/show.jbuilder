json.partial! 'loans/loan', loan: @loan

json.ledger do
  json.id @loan.ledger.id
  json.filename @loan.ledger_filename
  json.url @loan.view_ledger_url
end