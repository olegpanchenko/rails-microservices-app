module Queries
  class Products < Base
    DEFAULT_SORTING = { updated_at: :desc }
    SORTABLE_FIELDS = %i[created_at updated_at name price]

    def filters
      %i[filter_by_owner filter_by_name filter_by_price]
    end

    def sortable_fields
      SORTABLE_FIELDS
    end

    private

    def arel_table
      @arel_table ||= Product.arel_table
    end

    def filter_by_owner
      return if @options[:owner_id].nil?

      @scope = @scope.where(arel_table[:owner_id].eq(@options[:owner_id]))
    end

    def filter_by_name
      return if @options[:name].nil?

      @scope = @scope.where(arel_table[:name].matches("%#{@options[:name]}%"))
    end

    def filter_by_price
      @scope = @scope.where(arel_table[:price].gteq(@options[:price_min])) if @options[:price_min]
      @scope = @scope.where(arel_table[:price].lteq(@options[:price_max])) if @options[:price_max]
    end
  end
end
