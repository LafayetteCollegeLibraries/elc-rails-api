require 'csv'
require 'date'

namespace :el_camino do
  desc "import all items"
  task import: %w[
    import:subjects
    import:authors
    import:patrons
    import:works
    import:loans
  ]

  namespace :import do
    %w(subjects authors patrons works).each do |type|
      desc "import #{type}"
      task "#{type}" => :environment do
        model = type.titlecase.singularize.constantize
        file_path = File.expand_path("data/#{type}.csv", Rails.root)
        CSV.foreach(file_path, headers: true) {|row| model.create_from_csv_row!(row)}

        puts "Added #{model.count} #{type}"
      end
    end

    desc "imports loans + items"
    task :loans => :environment do
      # create the embodied_by dictionary
      EMBODIED_BY = {}
      embodied_by_path = File.expand_path('data/item-embodies-work.csv', Rails.root)
      CSV.foreach(embodied_by_path, headers: true) do |row|
        EMBODIED_BY[row['item_node_id'].to_i] = row['work_node_id'].to_i
      end

      (1..5).each do |ledger_id|
        csv_file_name = "loans-ledger-#{ledger_id}.csv"
        csv_path = File.expand_path("data/#{csv_file_name}", Rails.root)
        ledger = Ledger.find(ledger_id)
        line_no = 1
        works_created = 0

        CSV.foreach(csv_path, headers: true) do |row|
          line_no += 1

          node_id = row['node_id'].to_i
          loan = Loan.find_or_initialize_by(drupal_node_id: node_id)
        
          next unless loan.new_record?
          next if row['item_title'].blank?

          # let's just get everything out of the row that we need
          checkout_date = row['checkout_date']
          return_date = row['return_date']
          ledger_filename = row['ledger_filenames']

          shareholder_id = row['shareholder_node_id'].to_i
          representative_id = row['representative_node_id'].to_i
          work_id = row['item_node_id'].to_i

          # normalizing
          volumes = row['volumes'].split(/[;,]\s?/) if row['volumes']
          issues = row['issues'].split(/[;,]\s?/) if row['issues']
          years = row['years'].split(/[;,]\s?/) if row['years']

          # now let's get setting
          loan.checkout_date = checkout_date
          loan.return_date = return_date
          loan.ledger_filename = ledger_filename
          loan.ledger = ledger

          work_title = row['item_title']
                        .gsub(/\s?\[vol\. \d+\]\s?/i, ' ')
                        .gsub(/&quot;/, '"')
                        .gsub(/&amp;/, '&')

          work = Work.find_by(title: work_title)

          # TODO: don't do this. we don't want to skip things. maybe use as a
          # way to aggregate data to be revisited for clean-up
          if work.blank?
            work = Work.create do |w|
              w.title = work_title
              w.drupal_node_id = EMBODIED_BY[work_id] || work_id
              w.missing_from_csv = true
            end

            work.save!
            works_created += 1

            # puts "missing #{work_title}. [#{work_id}] @ loan-ledger-#{ledger_id}:#{line_no}"
            # next
          end

          # TODO: from what I can tell, a loan-item will only have
          # multiple volumes, so we'll iterate through those

          if volumes.present? && volumes.length
            items = volumes.each_with_index.inject([]) do |out, (v, i)|
              issue = issues[i] unless issues.blank?
              year = years[i] unless years.blank?
              out << Item.find_or_create_by(
                work: work,
                volume: v,
                issue: issue,
                year: year
              )
            end
          else
            issue = issues[0] unless issues.blank?
            year = years[0] unless years.blank?

            items = [Item.find_or_create_by(
              work: work,
              issue: issue,
              year: year
            )]
          end

          loan.items = items

          shareholder = Patron.find_or_initialize_by(drupal_node_id: shareholder_id)

          if shareholder.new_record?
            shareholder.name = row['shareholder_name']
            shareholder.save!
          end

          # TODO: this is a little long-winded + probably could be refactored
          representative = if (shareholder_id == representative_id)
                             shareholder
                           else
                             patron = Patron.find_or_initialize_by(drupal_node_id: representative_id)
                             if patron.new_record?
                               patron.name = row['representative_name']
                               patron.save!
                             end

                             patron
                           end

          loan.shareholder = shareholder
          loan.representative = representative

          loan.csv_source = "#{csv_file_name}:#{line_no}"

          begin
            loan.save!
          rescue
            puts loan.inspect
            raise $!
          end
        end

        puts "Added #{ledger.loans.count} loans to ledger #{ledger_id} (#{works_created} work#{works_created == 1 ? '' : 's'} created)"
      end
    end
  end
end

# Don Quixote [Vol. 2] (Duodecimo 8). [287192] @ loan-ledger-1:165

