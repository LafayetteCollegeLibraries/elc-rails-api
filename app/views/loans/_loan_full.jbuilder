json.partial! 'loans/common', loan: loan

json.ledger loan.ledger_id

json.item do
  json.partial! 'items/item_brief', item: loan.item
end

json.checkout_date loan.checkout_date
json.return_date loan.return_date

json.representative do
  if loan.representative.present?
    json.partial! 'partials/person', person: loan.representative
  else
    json.null!
  end
end

json.shareholder do 
  if loan.shareholder.present?
    json.partial! 'partials/person', person: loan.shareholder
  else
    json.null!
  end
end
