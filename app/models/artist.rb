class Artist < ApplicationRecord
  has_many :musics
  enum :gender, [:male, :female, :other], validate: true

  validates :name, presence: true
  validates :dob, presence: true
  validates :first_release_year, presence: true
  validates :no_of_albums_released, presence: true
  validates :address, presence: true
end
