class Artist < ApplicationRecord
  require "csv"

  has_many :musics
  enum :gender, [ :male, :female, :other ], validate: true

  validates :name, presence: true
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
      if row["dob"].present?
        row["dob"] = Date.strptime(row["dob"], "%m/%d/%Y").to_s
      end
      artist = Artist.find_by(id: row["id"])

      if artist.present?
        artist.update(row.to_h)
      else
        Artist.create!(row.to_h)
      end
    end
  end
end
