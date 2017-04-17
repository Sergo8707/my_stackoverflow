# frozen_string_literal: true
require 'sidekiq/web'
Rails.application.routes.draw do
  use_doorkeeper

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'questions#index'

  patch 'users/confirmation_email', to: 'users#confirmation_email', as: 'user_confirmation_email'

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resource :search, only: [:show]

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      member do
        patch :mark_best
      end
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

  resources :attachments, only: [:destroy]
  mount ActionCable.server => '/cable'
end
