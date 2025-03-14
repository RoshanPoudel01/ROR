class Music < ApplicationRecord
  belongs_to :artist
  enum :genre, [:mb, :country, :classic, :rock, :jazz], validate: true

  validates :title , presence: true
  validates :album_name, presence: true
end
