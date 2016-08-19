class Track
  include ActiveModel::Model

  attr_accessor :name, :spotify_id, :artist, :album
end