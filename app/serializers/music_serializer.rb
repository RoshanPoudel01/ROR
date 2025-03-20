class MusicSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :title, :album_name, :genre, :artist

  def genre
    object.genre.capitalize
  end
end
