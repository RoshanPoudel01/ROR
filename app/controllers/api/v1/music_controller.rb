class Api::V1::MusicController < ApplicationController
  include Paginatable
  before_action :authenticate

  def index
    music = Music.all
    @music = paginate(music)
    render json: @music, each_serializer: MusicSerializer, meta: paginate_meta(@music), adapter: :json, status: :ok
  end

  def create
    music = Music.new(music_params)
    if music.save
      render json: music, serializer: MusicSerializer, adapter: :json, status: :created
    else render json: {
      errors: music.errors.full_messages,
    }, status: :unprocessable_entity     end
  end

  def show
    music = Music.find(params[:id])
    render json: music, serializer: MusicSerializer, adapter: :json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found" }, status: :not_found
  end

  def show_by_artist
    artist = Artist.find_by(id: params[:artist_id])
    if artist.nil?
      render json: { error: "Artist not found" }, status: :not_found
    else
      music = Music.where(artist_id: params[:artist_id])
      render json: music, each_serializer: MusicSerializer, adapter: :json, status: :ok
    end
  end

  def update
    music = Music.find(params[:id])
    if music.update(music_params)
      render json: music, serializer: MusicSerializer, adapter: :json, status: :ok
    else
      render json: {
               errors: music.errors.full_messages,
             }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found" }, status: :not_found
  end

  def destroy
    music = Music.find(params[:id])
    music.destroy
    render json: { message: "Music deleted" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Music not found" }, status: :not_found
  end

  private

  def music_params
    params.permit(:title, :album_name, :genre, :artist_id)
  end
end
