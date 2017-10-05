json.extract! @loan, :id, :label

json.ledger @loan.ledger_id

json.item do
  json.partial! 'item/item', item: @loan.item
end

json.representative do
  if @loan.representative.present?
    json.partial! 'patron/person', person: @loan.representative
  else
    json.null!
  end
end

json.shareholder do 
  if @loan.shareholder.present?
    json.partial! 'patron/person', person: @loan.shareholder
  else
    json.null!
  end
end
