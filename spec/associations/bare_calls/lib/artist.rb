# frozen_string_literal: true

# The Artist test class.
class Artist < Sequel::Model
  many_to_many :albums

  one_through_one :album

  one_to_many :albums

  one_to_one :album
end
