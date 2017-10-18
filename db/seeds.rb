# NOTE: this is absolutely not production ready! I've been running into
# reconciliation problems with items listed in loans vs. those listed
# in items.csv (see [1] for a partial list; for now I'm also excluding
# items that may match on the `item_title` field). However, this should
# be plenty + thorough enough for development.
#
# [1]: https://gist.github.com/malantonio/f4504c1d144fb1f95caaee5025354236

require 'csv'
require 'date'

LEDGER_IDS = (1..5)

# so far our ledgers are just containers w/o any metadata
LEDGER_IDS.map {|n| Ledger.find_or_create_by(id: n) }

puts "Added #{Ledger.count} ledgers"

# stuff the person_type values, since there are only three
PersonType.find_or_create_by(label: 'Shareholder', drupal_node_id: 668)
PersonType.find_or_create_by(label: 'Representative', drupal_node_id: 669)
PersonType.find_or_create_by(label: 'Author', drupal_node_id: 230)

puts "Added #{PersonType.count} person types"

%w(subjects authors patrons).each do |type|
  model = type.titlecase.singularize.constantize
  file_path = File.expand_path("../../data/#{type}.csv", __FILE__)
  CSV.foreach(file_path, headers: true) {|row| model.create_from_csv_row!(row)}

  puts "Added #{model.count} #{type}"
end

item_csv_path = File.expand_path('../../data/works.csv', __FILE__)
CSV.foreach(item_csv_path, headers: true) do |row|
  author_id = row['author_node_id']
  subject_ids = row['subject_node_ids']

  node_id = row['node_id'].to_i
  title_node_id = row['title_node_id'].to_i
  title = row['item_title']

  item = Item.find_or_initialize_by(
           drupal_node_id: node_id,
           drupal_title_node_id: title_node_id,
           title: title
         )

  item.format = row['format']
  item.number = row['number'].to_i if row['number']

  item.subjects = Subject.where(drupal_node_id: subject_ids.split(';')) if subject_ids

  item.author = Author.find_by(drupal_node_id: author_id) if author_id.present?
  item.drupal_node_type = 'node'

  item.save!
end

puts "Added #{Item.count} items"

# create a map of items-to-works for loan records that refer to the item
# and not the work itself

EMBODIED_BY = {}
embodied_by_path = File.expand_path('../../data/item-embodies-target.csv', __FILE__)
CSV.foreach(embodied_by_path, headers: true) do |row|
  EMBODIED_BY[row['entity_id']] = row['target_id']
end

LEDGER_IDS.map do |ledger_id|
  ledger_csv_path = File.expand_path("../../data/loans-ledger-#{ledger_id}.csv", __FILE__)

  ledger = Ledger.find(ledger_id)
  line_no = 1
  
  CSV.foreach(ledger_csv_path, headers: true) do |row|
    line_no += 1

    shareholder_id = row['shareholder_node_id']
    representative_id = row['representative_node_id']
    item_id = row['item_node_id']

    item = Item.find_by_drupal_id(item_id)

    if item.blank?
      work_id = EMBODIED_BY[item_id]
      item = Item.find_by_drupal_id(work_id)
    end

    if item.blank?
      puts "missing #{row['item_title']}. [#{item_id}] @ loan-ledger-#{ledger_id}:#{line_no}"
      next
    end

    shareholder = Patron.find_by_drupal_id(shareholder_id)

    if (shareholder_id == representative_id)
      representative = shareholder
    else
      representative = Patron.find_by_drupal_id(representative_id)
    end

    loan = Loan.find_or_initialize_by(drupal_node_id: row['node_id'].to_i)
    loan.shareholder = shareholder
    loan.representative = representative
    loan.item = item

    loan.checkout_date = row['checkout_date']
    loan.return_date = row['return_date']

    loan.drupal_node_type = 'node'
    loan.ledger_filename = row['ledger_filenames']
    loan.ledger = ledger

    begin
      loan.save!
    rescue
      puts loan.inspect
      raise $!
    rescue 
    end
  end

  puts "Added #{ledger.loans.count} loans to ledger #{ledger_id}"
end
