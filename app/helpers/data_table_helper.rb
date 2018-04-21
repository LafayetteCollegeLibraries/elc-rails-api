module DataTableHelper
  include ActionView::Helpers::TagHelper

  def fields_for(model)
    case model
    when :works then %w(title authors subjects)
    when :loans then %w(shareholder representative item authors checkout_date return_date)
    else []
    end
  end


  def table_for(which)
    tag.table(table_attrs(which)) do
      tag.thead(class: 'thead-dark') do
        tag.tr do
          table_headers(fields_for(which))
          concat(tag.th style: 'width: 10%')
        end
      end
    end
  end

  def datatable_js_columns_for(which)
    fields = fields_for(which).map { |field| "{data: '#{field.to_s}'}" }.push('{data: "link"}')
    "[#{fields.join(',')}]".html_safe
  end

  private

  def table_attrs(which)
    {
      id: "#{which.to_s.pluralize}-table",
      class: 'table table-bordered table-sm table-responsive',
      'data-source': source_url(which),
    }
  end

  def source_url(which)
    send(:"#{which.to_s.pluralize}_path", format: :json)
  end

  def table_headers(fields)
    width = (90 / fields.count)
    fields.collect do |field|
      field_name = field.to_s.split('_').map(&:capitalize).join(' ')
      concat(tag.th(field_name, style: "width: #{width}%;"))
    end
  end
end
