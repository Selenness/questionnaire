require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  context 'with facebook' do
    describe "#annonymous user" do
      context "when facebook email doesn't exist in the system" do
        before(:each) do
          stub_env_for_fb_omniauth

          get :facebook
          @user = User.find_by_email(email: "test@test.test")
        end

        it { @user.should_not be_nil }

        it "should create authentication with facebook id" do
          authentication = @user.authorizations.where(provider: "facebook", uid: "1234").first
          authentication.should_not be_nil
        end

        it { should be_user_signed_in }

        it { response.should redirect_to root_path }
      end

      context "when facebook email already exist in the system" do
        before(:each) do
          stub_env_for_fb_omniauth

          User.create!(email: "test@test.test", password: "my_secret", password_confirmation: "my_secret")
          get :facebook
        end

        it { response.should redirect_to root_path }
      end
    end

    describe "#logged in user" do
      context "when user don't have facebook authorization" do
        before(:each) do
          stub_env_for_fb_omniauth

          user = User.create!(email: "test@test.test", password: "my_secret", password_confirmation: "my_secret")
          sign_in user

          get :facebook
        end

        it "should add facebook authentication to current user" do
          user = User.where(email: "test@test.test").first
          expect(user).not_to be_nil
          fb_authentication = user.authorizations.where(provider: "facebook").first
          expect(fb_authentication).not_to be_nil
          expect(fb_authentication.uid).to eq "1234"
        end

        it { expect(user_signed_in?).to be_true }

        it { response.should redirect_to root_path }
      end

      context "when user already connected with facebook" do
        before(:each) do
          stub_env_for_fb_omniauth

          user = User.create!(email: "test@test.test", password: "my_secret", password_confirmation: "my_secret")
          user.authorizations.create!(provider: "facebook", uid: "1234")
          sign_in user

          get :facebook
        end

        it "should not add new facebook authentication" do
          user = User.where(email: "test@test.test").first
          user.should_not be_nil
          fb_authorizations = user.authorizations.where(provider: "facebook")
          fb_authorizations.count.should == 1
        end

        it { should be_user_signed_in }

        it { response.should redirect_to root_path }

      end
    end
  end

  context 'with twitter' do
    describe "#annonymous user" do
      before(:each) do
        stub_env_for_tw_omniauth

        get :twitter
        @user = User.where(email: "test@test.test").first
      end

      it { @user.should be_nil }

      it { response.should redirect_to request_email_path(
                                           provider: 'twitter',
                                           uid: '1234'
                                       ) }
    end
  end

end

def stub_env_for_fb_omniauth
  # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/closed#issue/608
  request.env["devise.mapping"] = Devise.mappings[:user]

  request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
                                                            "provider"=>"facebook",
                                                            "uid"=>'1234',
                                                            'info' => {
                                                                'email' => 'test@test.test'
                                                            }
                                                        })
end

def stub_env_for_tw_omniauth
  # This a Devise specific thing for functional tests. See https://github.com/plataformatec/devise/issues/closed#issue/608
  request.env["devise.mapping"] = Devise.mappings[:user]

  request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
                                                            "provider"=>"twitter",
                                                            "uid"=>'1234',
                                                            'info' => {}
                                                        })
end