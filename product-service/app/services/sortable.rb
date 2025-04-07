module Sortable
  class InvalidSortableField < StandardError; end

  module ClassMethods
  end

  module InstanceMethods
    def default_sorting
      { created_at: :desc }
    end

    def sortable_fields
      [ :created_at ]
    end

    def field_keys
      {}
    end

    def sort_by
      sort_options = parse_sort_options(@options[:sort])
      @scope = @scope.order(sort_options)
    end

    private
    def parse_sort_options(sort)
      allowed = sortable_fields.map(&:to_s)
      fields = sort.to_s.split(",")

      order_fields = convert_to_order_hash(fields)

      order_fields.present? ? order_fields : default_sorting
    end

    def convert_to_order_hash(fields)
      fields.each_with_object({}) do |field, hash|
        direction = :asc
        if field.start_with?("-")
          field = field[1..-1]
          direction = :desc
        end

        field_key = field_key_for(field)
        hash[field_key] = direction
      end
    end

    def field_key_for(field)
      raise InvalidSortableField.new({ field: field, sortable_fields: sortable_fields }) unless sortable_fields.include?(field.to_sym)
      field_key = field_keys[field.to_sym]
      field_key = field if field_key.blank?

      field_key
    end
  end

  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end
end
