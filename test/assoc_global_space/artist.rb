require 'sequel'

class Artist < Sequel::Model
  one_to_many :albums
end