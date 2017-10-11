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

subject_csv_path = File.expand_path('../../data/subjects.csv', __FILE__)
CSV.foreach(subject_csv_path, headers: true) do |row|
  Subject.create_from_csv_row!(row)
end

puts "Added #{Subject.count} subjects"

author_csv_path = File.expand_path('../../data/authors.csv', __FILE__)
CSV.foreach(author_csv_path, headers: true) do |row|
  author = Author.find_or_initialize_by(drupal_node_id: row['node_id'].to_i)

  author.name = row['name']
  author.drupal_node_type = 'node'

  author.save!
end

puts "Added #{Author.count} authors"

patron_csv_path = File.expand_path('../../data/people.csv', __FILE__)
CSV.foreach(patron_csv_path, headers: true) do |row|
  type_node_ids = row['person_type_node_ids']
  
  patron = Patron.find_or_initialize_by(drupal_node_id: row['node_id'].to_i)

  patron.name = row['name']
  patron.person_types = type_node_ids.split(';').map do |id|
    PersonType.find_by(drupal_node_id: id)
  end.reject { |i| i.blank? } if type_node_ids.present?

  patron.save!
end

puts "Added #{Patron.count} patrons"

item_csv_path = File.expand_path('../../data/items.csv', __FILE__)
CSV.foreach(item_csv_path, headers: true) do |row|
  author_id = row['author_node_id']
  subject_ids = row['subject_node_ids']

  node_id = row['node_id'].to_i
  title_node_id = row['title_node_id'].to_i
  # title = row['item_title'].gsub(/\s?\[vol[^\]]+\]\s?/i, ' ')
  title = row['item_title']

  item = Item.find_or_initialize_by(
           drupal_node_id: node_id,
           drupal_title_node_id: title_node_id,
           title: title
         )

  item.title = row['item_title']
  item.format = row['format']
  item.number = row['number'].to_i if row['number']

  item.subjects = subject_ids.split(';').map do |id|
    Subject.find_by(drupal_node_id: id)
  end.reject { |s| s.blank? } if subject_ids.present?

  item.author = Author.find_by(drupal_node_id: author_id) if author_id.present?
  item.drupal_node_type = 'node'
  item.drupal_title_node_id = row['title_node_id']

  item.save!
end

puts "Added #{Item.count} items"

LEDGER_IDS.map do |ledger_id|
  ledger_csv_path = File.expand_path("../../data/loans-ledger-#{ledger_id}.csv", __FILE__)

  ledger = Ledger.find(ledger_id)
  
  CSV.foreach(ledger_csv_path, headers: true) do |row|
    shareholder_id = row['shareholder_node_id']
    representative_id = row['representative_node_id']
    item_id = row['item_node_id']

    # I hate this but I'm running into issues where items attached to a loan record
    # aren't in the Items list?
    item = Item.find_by_drupal_id(item_id)

    if item.blank?
      item = Item.find_by(drupal_title_node_id: item_id)
    end

    if item.blank?
      puts "couldn't find #{row['item_title']}. skipping loan-ledger-#{ledger_id}:#{row['node_id']}"
      next
    end

    shareholder = Patron.find_by(drupal_node_id: shareholder_id)

    if (shareholder_id == representative_id)
      representative = shareholder
    else
      representative = Patron.find_by(drupal_node_id: representative_id)
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
