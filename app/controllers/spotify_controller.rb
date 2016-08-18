require 'rest-client'
require 'uri'
require 'base64'

class SpotifyController < ApplicationController
  protect_from_forgery with: :exception
  before_action :set_user, only: [:dashboard]

  @@secret = ENV['SPOTIFY_SECRET']
  @@client_id = ENV['SPOTIFY_CLIENT_ID']
  @@redirect_url = ENV['SPOTIFY_REDIRECT_URL']
  @@scope_take_me_out = ['playlist-read-private',
    'playlist-read-collaborative',
    'playlist-modify-public',
    'playlist-modify-private',
    'user-follow-modify',
    'user-follow-read',
    'user-library-read',
    'user-library-modify',
    'user-read-private',
    'user-read-birthdate',
    'user-read-email',
    'user-top-read']

  def show
    render "index"
  end

  def login_user
    @spotify_random = SecureRandom.hex

    query_params = URI.encode_www_form({
      :client_id => @@client_id,
      :response_type => 'code',
      :redirect_uri => @@redirect_url,
      :scope => @@scope_take_me_out.join(' '),
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
      redirect_to "/spotify"
      return
    end

    redirect_to "/spotify/dashboard"
  end

  def dashboard
    render "dashboard"
  end

  private

  def set_user
    begin
      response = RestClient.get('https://api.spotify.com/v1/me',
      {:Authorization => "Bearer #{session[:access_token]}"})
    rescue Exception => e
      redirect_to "/spotify"
      return
    end

    @user = parse_spotify_user_take_me_out(JSON.parse(response.body))
  end

  def parse_spotify_user_take_me_out (spotify_user)
   User.new(
    name: spotify_user['display_name'],
    country: spotify_user['country'],
    image: spotify_user['images'].first['url'],
    product: spotify_user['product'],
    email: spotify_user['email'])
  end

end