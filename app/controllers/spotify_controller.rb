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
    @spotify_random = SecureRandom.hex

    query_params = URI.encode_www_form({
      :client_id => @@client_id,
      :response_type => 'code',
      :redirect_uri => @@redirect_url,
      :scope => Spotify::REQUIRED_SCOPES.join(' '),
      :state => @spotify_random
    })

    redirect_to("https://accounts.spotify.com/authorize/?#{query_params}")
  end

  def authorize_finish
    spotify_auth_code = request.query_parameters['code']
    authorization = Base64.strict_encode64("#{@@client_id}:#{@@secret}")

    state = request.query_parameters['state']
    saved_state = params['state']

    unless state.eql? saved_state
      logger.error "Seems the request has been tempered with, the states do not match"
      redirect_to '/spotify/', :flash => { :error => "Spotify Authorization failed" }
      return
    end

    begin
      response = RestClient.post('https://accounts.spotify.com/api/token', {
        grant_type: 'authorization_code',
        code: spotify_auth_code,
        redirect_uri: @@redirect_url
      }, {:Authorization => "Basic #{authorization}"})

      session[:access_token] = JSON.parse(response.body)['access_token']
      session[:refresh_token] = JSON.parse(response.body)['refresh_token']

    rescue Exception => e
      logger.error "Error getting the token from Spotify: #{e.message}"
      redirect_to "/spotify"
      return
    end

    redirect_to "/spotify/dashboard"
  end

  def dashboard
    begin

      @following = Spotify.get_followed_artists(session[:access_token]).sort_by!{ |artist| artist.name.downcase }
      @top_artists = Spotify.get_top_artists(session[:access_token])
      @top_tracks = Spotify.get_top_tracks(session[:access_token])

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
      @user = Spotify.get_user(session[:access_token])
    rescue Exception => e
      logger.error "Error getting user info from Spotify: #{e.message}"
      redirect_to "/spotify"
      return
    end
  end

end