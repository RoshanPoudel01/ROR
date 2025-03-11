class Artist < ApplicationRecord
  enum :gender, [:male, :female, :other]
end
