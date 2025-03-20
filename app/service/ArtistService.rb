class ArtistService
    require "csv"
    def initialize
        @artists
    end

    def all_artists
        Artist.all.order(id: :asc)
    end

    def create_artist(artist_params)
        Artist.new(artist_params).tap do |artist|
            puts artist_params
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

    def to_csv
        CSV.generate(headers: true) do |csv|
          @artists =  Artist.all
            @artists.each do |item|
              csv << [ item.name, item.id ]
            end
        end
    end
end
