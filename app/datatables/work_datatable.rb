class WorkDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      title: { source: 'Work.title' },
      authors: { source: 'Author.name' },

    }
  end

  def data
    records.map do |record|
      {
        title: record.title,
        authors: record.authors.map(&:name).join(', '),
        # link: link_to 'View', record
      }
    end
  end

  private

  def get_raw_records
    # Work.joins({ authors: })
    Work.all
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
