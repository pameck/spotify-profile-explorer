module Spotify

  ALL_SCOPES = ['playlist-read-private',
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

  ME_API_URL = 'https://api.spotify.com/v1/me'

  def self.parse_user (spotify_user)
    User.new(
      name: spotify_user['display_name'],
      country: spotify_user['country'],
      image: spotify_user['images']&.first['url'],
      product: spotify_user['product'],
      email: spotify_user['email'])
  end

  def self.parse_artists_list (spotify_artists_list)

    spotify_artists_list['items'].map { |spotify_artist|
      self.parse_artist(spotify_artist)
    }
  end

  def self.parse_artist(spotify_artist)
    Artist.new(
      name: spotify_artist['name'],
      spotify_id: spotify_artist['id'],
      genre: spotify_artist['genre'],
      image: spotify_artist['images']&.first['url'],
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

end