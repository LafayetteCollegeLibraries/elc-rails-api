class LoanDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      items: { source: 'Item.title' },
      checkout_date: { source: 'Loan.checkout_date' },
      return_date: { source: 'Loan.return_date' },
      shareholder: { source: 'Patron.name' },
      representative: { source: 'Patron.name' }
    }
  end

  def data
    records.map do |loan|
      # this is really messy, but necessary if we're keeping the potential
      # open for multiple items per loan (which tbh is a code smell and a
      # point for refactoring in the future)
      authors = loan.items.collect(&:authors).flatten.collect(&:name).join(', ')

      {
        shareholder: loan.shareholder.name,
        representative: loan.representative.name,
        item: loan.items.collect(&:title).join(', '),
        authors: authors,
        checkout_date: loan.checkout_date.strftime('%m-%d-%Y'),
        return_date: loan.checkout_date.strftime('%m-%d-%Y'),
        link: link_to('View', loan, class: 'btn btn-info')
      }
    end
  end

  private

  def get_raw_records
    join_text = <<-END
      INNER JOIN patrons on
        loans.shareholder_id = patrons.id
        AND loans.representative_id = patrons.id
    END

    Loan.joins(join_text).all
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
