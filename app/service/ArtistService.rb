class ArtistService
    def initialize
    end

    def all_artists
        Artist.all
    end

    def create_artist(artist_params)
        Artist.new(artist_params).tap do |artist|
            artist.save
        end
    end

    def find_artist(id)
        Artist.find_by(id: id)
    end

    def update_artist(artist, artist_params)
        artist.update(artist_params)
        artist
    end

    def destroy_artist(artist)
        artist.destroy
    end
end