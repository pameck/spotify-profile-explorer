require 'test_helper'

class UserProfileTest < ActiveSupport::TestCase

  test "should create an empty user when initialized with no params" do
    user = UserProfile.new
    assert_not_nil(user, 'user cannot be empty')
  end

  test "should create a populated user when initialized with data" do
    user = UserProfile.new(
      name: 'Fulano de Tal',
      image: 'some url')

    assert_not_nil(user, 'user cannot be empty')
    assert_not_nil(user.name, 'user name cannot be empty')
    assert_not_nil(user.image, 'user image cannot be empty')
  end

end
