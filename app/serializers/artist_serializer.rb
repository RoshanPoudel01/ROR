class ArtistSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :name, :dob, :gender, :address, :first_release_year, :no_of_albums_released, :music_count

  def gender
    object.gender.capitalize
  end

  def music_count
    object.musics.count
  end
end
