# frozen_string_literal: true

# The Album test class.
class Album < Sequel::Model
  many_to_one :artist
end
