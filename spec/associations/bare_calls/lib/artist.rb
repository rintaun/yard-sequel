# frozen_string_literal: true

# The Artist test class.
class Artist < Sequel::Model
  one_to_many :albums
end
