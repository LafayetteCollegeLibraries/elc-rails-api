require 'csv'

subject_csv_path = File.expand_path('../../data/subjects.csv', __FILE__)
CSV.foreach(subject_csv_path, headers: true) do |row|
  subject = Subject.new
  
  subject.label = row['label']
  subject.drupal_node_id = row['taxonomy_id'].to_i if row['taxonomy_id']
  subject.drupal_node_type = 'taxonomy'

  subject.save!
end

author_csv_path = File.expand_path('../../data/authors.csv', __FILE__)
CSV.foreach(author_csv_path, headers: true) do |row|
  author = Author.new

  author.name = row['name']
  author.drupal_node_id = row['node_id'].to_i if row['node_id']
  author.drupal_node_type = 'node'

  author.save!
end

item_csv_path = File.expand_path('../../data/items.csv', __FILE__)
CSV.foreach(item_csv_path, headers: true) do |row|
  author_id = row['author_node_id']
  subject_ids = row['subject_node_ids']

  item = Item.new

  item.title = row['item_title'].gsub(/\s?\[vol[^\]]+\]\s?/i, ' ')
  item.format = row['format']
  item.number = row['number'].to_i if row['number']

  item.subjects = subject_ids.split(';').map do |id|
    Subject.find_by(drupal_node_id: id)
  end.reject { |s| s.blank? } if subject_ids.present?

  item.author = Author.find_by(drupal_node_id: author_id) if author_id.present?

  item.drupal_node_id = row['title_node_id'] || row['node_id']
  item.drupal_node_type = 'node'

  item.save!
end

# stuff the person_type values, since there are only three
PersonType.create(label: 'Shareholder', drupal_node_id: 668)
PersonType.create(label: 'Representative', drupal_node_id: 669)
PersonType.create(label: 'Author', drupal_node_id: 230)

patron_csv_path = File.expand_path('../../data/people.csv', __FILE__)
CSV.foreach(patron_csv_path, headers: true) do |row|
  type_node_ids = row['person_type_node_ids']
  
  patron = Patron.new

  patron.name = row['name']
  patron.person_types = type_node_ids.split(';').map do |id|
    PersonType.find_by(drupal_node_id: id)
  end.reject { |i| i.blank? } if type_node_ids.present?

  patron.drupal_node_id = row['node_id']

  patron.save!
end