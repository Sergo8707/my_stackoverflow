# frozen_string_literal: true
Rails.application.routes.draw do

  devise_for :users
  root to: "question#index"

  resources :questions do
    resources :answers
  end
end
