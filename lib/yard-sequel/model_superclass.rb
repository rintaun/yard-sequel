# frozen_string_literal: true

# Patches ClassHandler#parse_superclass to recognize Sequel::Model(:table)-style
# superclass definitions.

require 'yard/handlers/ruby/class_handler'

class YARD::Handlers::Ruby::ClassHandler
  unless defined? __orig_parse_superclass__
    alias_method :__orig_parse_superclass__, :parse_superclass
    def parse_superclass(superclass)
      return if superclass.nil?
      parsed = __orig_parse_superclass__(superclass)
      return parsed unless parsed.nil?
      return unless superclass.type == :call

      # if superclass.namespace.to
      if superclass.namespace.source.to_sym == :Sequel && superclass.method_name(true) == :Model
        return 'Sequel::Model'
      end
      nil
    end
  end
end
