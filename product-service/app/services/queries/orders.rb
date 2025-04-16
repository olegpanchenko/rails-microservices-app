module Queries
  class Orders < Base
    DEFAULT_SORTING = { updated_at: :desc }
    SORTABLE_FIELDS = %i[created_at updated_at name price]

    def filters
      %i[filter_by_status]
    end

    def sortable_fields
      SORTABLE_FIELDS
    end

    private

    def arel_table
      @arel_table ||= Order.arel_table
    end

    def filter_by_status
      return if @options[:status].blank?

      @scope = @scope.where(arel_table[:status].eq(@options[:status]))
    end
  end
end
