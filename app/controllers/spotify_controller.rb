require 'rest-client'
require 'uri'
require 'base64'
require 'spotify'

class SpotifyController < ApplicationController

  protect_from_forgery with: :exception
  before_action :set_user, only: [:dashboard]

  @@secret = ENV['SPOTIFY_SECRET']
  @@client_id = ENV['SPOTIFY_CLIENT_ID']
  @@redirect_url = ENV['SPOTIFY_REDIRECT_URL']

  def show
    render "index"
  end

  def login_user
    spotify_random = SecureRandom.hex

    session[:spotify_random] = spotify_random

    # move this out of here, dependency injection, how is it done? I need a singleton for this!
    spotify_client = SpotifyClient.new(secret: @@secret, client_id: @@client_id)
    redirect_to(spotify_client.get_user_login_url(Spotify::REQUIRED_SCOPES, @@redirect_url, spotify_random))
  end

  def authorize_finish
    begin
      # move this out of here, dependency injection, how is it done? I need a singleton for this!
      spotify_client = SpotifyClient.new(secret: @@secret, client_id: @@client_id)
      spotify_session = spotify_client.authorize(params['code'], @@redirect_url, session[:spotify_random], params['state'])

      session[:spotify_session] = spotify_session

    rescue Exception => e
      logger.error "Error getting the token from Spotify: #{e.message}"
      redirect_to "/spotify"
      return
    end

    redirect_to "/spotify/dashboard"
  end

  def dashboard
    access_token = session[:spotify_session].access_token
    begin
      @following = Spotify.get_followed_artists(access_token).sort_by!{ |artist| artist.name.downcase }
      @top_artists = Spotify.get_top_artists(access_token)
      @top_tracks = Spotify.get_top_tracks(access_token)

    rescue Exception => e
      logger.error "Error loading the board: #{e.message}"
      redirect_to "/spotify"
      return
    end

    render "dashboard"
  end

  private

  def set_user
    begin
      @user = Spotify.get_user(session[:spotify_session].access_token)
    rescue Exception => e
      logger.error "Error getting user info from Spotify: #{e.backtrace.join("\n")}"
      redirect_to "/spotify"
      return
    end
  end

end