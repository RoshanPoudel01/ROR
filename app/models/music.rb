class Music < ApplicationRecord
  belongs_to :artist
  enum :genre, [:mb, :country, :classic, :rock, :jazz]
end
