module Spotify

  REQUIRED_SCOPES = ['user-follow-read', 'user-top-read']
  ALL_SCOPES = ['playlist-read-private',
    'playlist-read-collaborative',
    'user-follow-read',
    'user-library-read',
    'user-read-private',
    'user-top-read']

  @me_api_url = 'https://api.spotify.com/v1/me'
  @endpoints = {
    :top_tracks => @me_api_url + '/top/tracks',
    :top_artists => @me_api_url + '/top/artists',
    :followed_artists => @me_api_url + '/following?type=artist'
  }

  def self.get_user(auth_token)
    response = get(@me_api_url, auth_token)
    parse_user(JSON.parse(response.body))
  end

  def self.get_top_tracks(auth_token)
    response = get(@endpoints[:top_tracks], auth_token)
    parse_tracks_list(JSON.parse(response.body))
  end

  def self.get_top_artists(auth_token)
    response = get(@endpoints[:top_artists], auth_token)
    parse_artists_list(JSON.parse(response.body))
  end

  def self.get_followed_artists(auth_token)
    response = get(@endpoints[:followed_artists], auth_token)
    parse_artists_list(JSON.parse(response.body)['artists'])
  end

  def self.parse_user (spotify_user)
    User.new(
      name: spotify_user['display_name'],
      image: spotify_user.dig('images', 0, 'url'))
  end

  def self.parse_artists_list (spotify_artists_list)
    spotify_artists_list['items'].map { |spotify_artist|
      parse_artist(spotify_artist)
    }
  end

  def self.parse_artist(spotify_artist)
    Artist.new(
      name: spotify_artist['name'],
      spotify_id: spotify_artist['id'],
      genre: spotify_artist['genre'],
      image: spotify_artist.dig('images', 0, 'url'),
      popularity: spotify_artist['popularity'],
      followers_qty: spotify_artist['followers']['total'])
  end

  def self.parse_tracks_list (spotify_tracks_list)

    spotify_tracks_list['items'].map { |spotify_track|
      self.parse_track(spotify_track)
    }
  end

  def self.parse_track(spotify_track)
    Track.new(
      name: spotify_track['name'],
      spotify_id: spotify_track['id'],
      artist: spotify_track['artists'].first['name'],
      album: spotify_track['album']['name'])
  end

  def self.get(url, auth_token)
    RestClient.get(url, {:Authorization => "Bearer #{auth_token}"})
  end

end