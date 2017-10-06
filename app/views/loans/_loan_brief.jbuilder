json.partial! 'loans/common', loan: loan

json.item loan.item.title

json.representative do
  if loan.representative.present?
    loan.representative.name
  else
    json.null!
  end
end

json.shareholder do
  if loan.shareholder.present?
    loan.shareholder.name
  else
    json.null!
  end
end

