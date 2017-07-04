Rails.application.routes.draw do

  use_doorkeeper

  get 'request_email' => 'request_email#request_email', as: :request_email
  get 'email_confirmation' => 'request_email#email_confirmation'
  post 'confirm_email' => 'request_email#send_confirmation_email'
  get 'confirm' => 'request_email#receive_confirmation', as: :receive_confirmation
  get 'thank_you' => 'request_email#confirmation_email_sent', as: :email_sent

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :profiles_list, on: :collection
      end
      resources :questions, only: [:index] do
        # get :index, on: :collection
      end
    end
  end


  resources :user_votes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :questions do
    resources :answers, shallow: true do
      patch 'set_best', on: :member
    end
  end

  delete 'attachments/:id' => 'attachments#destroy'
  root to: "questions#index"

  mount ActionCable.server => './cable'
end
