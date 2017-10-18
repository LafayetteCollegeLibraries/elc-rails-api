json.extract! loan, :id, :label

json.item do
  json.partial! 'items/item', item: loan.item

  # TODO: implement these fields on the loan
  json.volumes loan.volumes
  json.issues loan.issues
  json.years loan.years
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

json.ledger do
  json.id loan.ledger.id
  json.filename loan.ledger_filename
  json.url loan.view_ledger_url
end