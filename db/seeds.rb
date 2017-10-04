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
  end.reject { |s| s.blank? } if subject_ids

  item.author = Author.find_by(drupal_node_id: author_id) if author_id

  item.drupal_node_id = row['title_node_id'] || row['node_id']
  item.drupal_node_type = 'node'

  item.save!
end