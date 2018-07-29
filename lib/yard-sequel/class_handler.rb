# frozen_string_literal: true

module YardSequel
  # Module for ClassHandler patch
  # @author Matthew Lanigan <rintaun@gmail.com>
  module ClassHandler
    # Patch for {Yard::Handlers::Ruby::ClassHandler#parse_superclass} to
    # recognize Sequel::Model(:table) as a superclass rather than giving
    # undocumentable superclass warnings.
    #
    # As Sequel::Model(:table) is the recommended way of specifying the dataset
    # for a model, this should be supported.
    def parse_superclass(superclass)
      parsed = super
      return parsed unless parsed.nil?
      return if superclass&.type != :call

      if superclass.namespace.source.to_sym == :Sequel &&
         superclass.method_name(true) == :Model
        return 'Sequel::Model'
      end
      nil
    end
  end
end

require 'yard/handlers/ruby/class_handler'
class YARD::Handlers::Ruby::ClassHandler
  prepend YardSequel::ClassHandler
end
