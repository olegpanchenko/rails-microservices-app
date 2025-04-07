module Queries
  class Base
    include Sortable
    include Paginable

    attr_reader :scope

    def initialize(scope, options = {})
      @scope = scope
      @options = options
    end

    def call
      filters.each do |filter|
        method(filter).to_proc.call
      end
      sort_by
      paginate
      @scope
    end
  end
end
