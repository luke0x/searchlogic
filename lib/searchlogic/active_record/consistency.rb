module Searchlogic
  module ActiveRecord
    # Active Record is pretty inconsistent with how their SQL is constructed. This
    # method attempts to close the gap between the various inconsistencies.
    module Consistency
      def self.included(klass)
        klass.class_eval do
          alias_method_chain :merge_joins, :searchlogic
        end
      end
    
      # In AR multiple joins are sometimes in a single join query, and other times they
      # are not. The merge_joins method in AR should account for this, but it doesn't.
      # This fixes that problem. This way there is one join per string, which allows
      # the merge_joins method to delete duplicates.
      def merge_joins_with_searchlogic(*args)
        joins = merge_joins_without_searchlogic(*args)
        joins.collect { |j| j.is_a?(String) ? j.split("  ") : j }.flatten.uniq
      end
    end
  end
end