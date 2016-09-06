require 'rest-client'
require 'uri'
require 'base64'

class SpotifyController < ApplicationController

  protect_from_forgery with: :exception

  @@secret = ENV['SPOTIFY_SECRET']
  @@client_id = ENV['SPOTIFY_CLIENT_ID']
  @@redirect_url = ENV['SPOTIFY_REDIRECT_URL']
  REQUIRED_SCOPE = ['user-follow-read', 'user-top-read']

  def show
    render "index"
  end

  def login_user
    spotify_random = SecureRandom.hex

    session[:spotify_random] = spotify_random

    # move this out of here, dependency injection, how is it done? I need a singleton for this!
    spotify_client = SpotifyClient.new(secret: @@secret, client_id: @@client_id, scope: REQUIRED_SCOPE)
    redirect_to(spotify_client.get_user_login_url(@@redirect_url, spotify_random))
  end

  def authorize_finish
    begin
      # move this out of here, dependency injection, how is it done? I need a singleton for this!
      spotify_client = SpotifyClient.new(secret: @@secret, client_id: @@client_id, scope: REQUIRED_SCOPE)
      spotify_user = spotify_client.connect(params['code'], @@redirect_url, session[:spotify_random], params['state'])

      session[:spotify_user] = spotify_user

    rescue Exception => e
      logger.error "Error getting the token from Spotify: #{e.message}"
      redirect_to "/spotify"
      return
    end

    redirect_to "/spotify/dashboard"
  end

  def dashboard
    begin
      spotify_user = SpotifyConnectedUser.new(
        access_token: session[:spotify_user]['access_token'],
        refresh_token: session[:spotify_user]['refresh_token']
      )

      @user = spotify_user.get_profile
      @top_tracks = spotify_user.get_top_tracks
      @top_artists = spotify_user.get_top_artists
      @following = spotify_user.get_followed_artists.sort_by!{ |artist| artist.name.downcase }

    rescue Exception => e
      logger.error "Error loading the board: #{e.message}"
      redirect_to "/spotify"
      return
    end

    render "dashboard"
  end
end