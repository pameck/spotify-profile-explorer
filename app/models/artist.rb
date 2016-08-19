class Artist
  include ActiveModel::Model

  attr_accessor :name, :spotify_id, :genre, :image, :popularity, :followers_qty
end