require "active_support/concern"

module ProgrammingLabsPrefix
  extend ActiveSupport::Concern

  class_methods do
    # look in app/views/programming_labs for partials
    def _prefixes
      super | %w[programming_labs]
    end
  end
end
