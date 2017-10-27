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

Rake::Task['el_camino:import'].invoke
