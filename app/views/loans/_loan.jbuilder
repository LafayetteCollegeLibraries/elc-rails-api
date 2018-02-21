json.extract! loan, :id, :label

json.work do
  json.partial! 'works/work', work: loan.work
end

json.volumes loan.volumes_borrowed
json.issues loan.issues_borrowed
json.years loan.years_borrowed

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
