# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    resources :votes, only: [:create, :destroy]
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: :votable, shallow: true do
      member do
        patch :mark_best
      end
    end
  end
  resources :attachments, only: [:destroy]
  mount ActionCable.server => '/cable'
end
