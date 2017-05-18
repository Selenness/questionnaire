module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:twitter] = twitter_hash

    OmniAuth.config.mock_auth[:facebook] = facebook_hash
  end

  def twitter_hash
    OmniAuth::AuthHash.new({
                               provider: 'twitter',
                               uid: '123456',
                               user_info: {
                                   name: 'mockuser',
                                   image: 'mock_user_thumbnail_url'
                               },
                               credentials: {
                                   token: 'mock_token',
                                   secret: 'mock_secret'
                               },
                               info: {
                                   email: 'mockuser@test.com'
                               }
                           })
  end

  def facebook_hash
    OmniAuth::AuthHash.new({
                               provider: 'facebook',
                               uid: '1234567',
                               info: {
                                   email: 'mockuser@test.com',
                               }
                           })
  end
end

