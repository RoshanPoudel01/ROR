class Artist < ApplicationRecord
  require "csv"

  has_many :musics
  enum :gender, [ :male, :female, :other ], validate: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :dob, presence: true
  validates :first_release_year, presence: true
  validates :no_of_albums_released, presence: true
  validates :address, presence: true

  def self.to_csv
    attributes = %w[id name dob first_release_year no_of_albums_released address]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def self.import_csv(file)
    CSV.foreach(file.path, headers: true) do |row|
      # Convert the 'dob' field from MM/DD/YYYY to YYYY-MM-DD
      # if row["dob"].present?
      #   puts row["dob"]
      #   row["dob"] = Date.strptime(row["dob"], "%m/%d/%Y").to_s
      # end
      artist_hash={}
      artist_hash[:name] = row["name"]
      artist_hash[:dob] = row["dob"]
      artist_hash[:gender]=row["gender"].downcase
      artist_hash[:first_release_year] = row["first_release_year"]
      artist_hash[:no_of_albums_released] = row["no_of_albums_released"]
      artist_hash[:address] = row["address"]
      artist = Artist.find_by(name: row["name"])
      puts artist
      if artist.present?
        artist.update(artist_hash)
      else
        Artist.create!(artist_hash)
      end
    end
  end
end
