module UsersHelper
  def user_avatar(user)
    user.avatar.attached? ? user.avatar : asset_url('no_image.png')
  end
end
