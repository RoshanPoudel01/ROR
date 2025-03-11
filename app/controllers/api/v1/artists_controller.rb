class Api::V1::ArtistsController < ApplicationController
  include Paginatable
  before_action :authenticate

  def index
    artists = Artist.all
    @artists = paginate(artists)
    render json: @artists, each_serializer: ArtistSerializer, meta: paginate_meta(@artists), adapter: :json, status: :ok
  end

  def show
    artist = Artist.find(params[:id])
    render json: artist, serializer: ArtistSerializer, adapter: :json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Artist not found" }, status: :not_found
  end

  def create
    artist = Artist.new(artist_params)
    if artist.save
      render json: artist, serializer: ArtistSerializer, status: :created
    else
      render json: { errors: artist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    artist = Artist.find(params[:id])
    if artist.update(artist_params)
      render json: artist, serializer: ArtistSerializer, status: :ok
    else
      render json: {
               errors: artist.errors.full_messages,
             }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Artist not found" }, status: :not_found
  end

  def destroy
    artist = Artist.find(params[:id])
    artist.destroy
    render json: { message: "Artist deleted" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Artist not found" }, status: :not_found
  end

  private

  def artist_params
    params.permit(:name, :dob, :gender, :address, :first_release_year, :no_of_albums_released)
  end
end
