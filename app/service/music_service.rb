class MusicService

    def initialize
    end

    def all_musics
        Music.all.order(id: :asc)
    end

    def create_music(music_params)
        Music.new(music_params).tap do |music|
            music.save
        end
    end

    def find_music(id)
        Music.find_by(id: id)
    end

    def update_music(music,music_params)
        music.update(music_params)
        music
    end

    def destroy_music(music)
        music.destroy
    end

    def find_by_artist(artist_id)
        Music.where(artist_id: artist_id)
    end

end