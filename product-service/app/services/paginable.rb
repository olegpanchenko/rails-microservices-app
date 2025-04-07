module Paginable
  module ClassMethods
  end

  module InstanceMethods
    def paginate
      page = @options[:page] || 1
      per_page = @options[:per_page] || 20

      @scope = @scope.page(page).per(per_page)
    end
  end

  def self.included(base)
    base.extend         ClassMethods
    base.send :include, InstanceMethods
  end
end
