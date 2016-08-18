class User
  include ActiveModel::Model

  attr_accessor :name, :spotify_id, :product, :image, :email, :country
end