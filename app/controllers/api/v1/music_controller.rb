class Api::V1::MusicController < ApplicationController
  include Paginatable
  before_action :authenticate

  def initialize
    @music_service = MusicService.new
    @artist_service = ArtistService.new
  end

  def index
    music = @music_service.all_musics
    @music = paginate(music)
    render json: @music, each_serializer: MusicSerializer, meta: paginate_meta(@music), adapter: :json, status: :ok
  end

  def create
    music = @music_service.create_music(music_params)
    if music.errors.any?
      raise ActiveRecord::RecordInvalid.new(music)
    elsif music.persisted?
      render json: {
        message:"Music created successfully",
        data: MusicSerializer.new(music),
        status: :created
      }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: "Validation failed",
      message: "Please check the provided data.",
      details: e.record.errors.full_messages
    }, status: :unprocessable_entity
  rescue StandardError
    render json: {
      error: "Internal server error",
      message: "Something went wrong. Please try again later."
    }, status: :internal_server_error
  end

  def show
   music = @music_service.find_music(params[:id])
   raise ActiveRecord::RecordNotFound if music.nil?
    render json: music, serializer: MusicSerializer, adapter: :json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found", 
    message: "The music you are looking for doesnot exist" 
    }, status: :not_found
  rescue StandardError
    render json: {
      error: "Internal server error",
      message: "Something went wrong. Please try again later."
    },status: :internal_server_error
  end

  def show_by_artist
    artist = @artist_service.find_artist(params[:artist_id])
    raise ActiveRecord::RecordNotFound if artist.nil?
    music = @music_service.find_by_artist(params[:artist_id])
    render json: music, each_serializer: MusicSerializer, adapter: :json, status: :ok
    rescue ActiveRecord::RecordNotFound
    render json: { error: "Artist not found",
    message: "The artist you are looking for does not exist"
    },status: :not_found
    rescue StandardError
      render json:{
        error: "Internal server error",
        message: "Something went wrong. Please try again later."
      }, status: :internal_server_error
  end

  def update
    music = @music_service.find_music(params[:id])

    raise ActiveRecord::RecordNotFound if music.nil?

    if music.artist_id != music_params[:artist_id].to_i
      render json: { error: "Artist ID cannot be changed" }, status: :unprocessable_entity
      return
    end

    updated_music = @music_service.update_music(music, music_params)

    if updated_music.errors.any?
      raise ActiveRecord::RecordInvalid.new(updated_music)
    elsif updated_music.persisted?
      render json: {
        status: :ok,
        data: MusicSerializer.new(updated_music),
        message: "Music updated successfully"
      }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: "Validation failed",
      message: "Please check the provided data.",
      details: e.record.errors.full_messages
    }, status: :unprocessable_entity
  
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found",
    meassage: "The music you are looking for does not exist"
    }, status: :not_found
  end

  def destroy
    music = @music_service.find_music(params[:id])
    raise ActiveRecord::RecordNotFound if music.nil?
    @music_service.destroy_music(music)
    render json: { message: "Music deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found", 
    message: "The music you are looking for doesnot exist"
     }, status: :not_found
  end

  private

  def music_params
    params.permit(:title, :album_name, :genre, :artist_id)
  end
end
