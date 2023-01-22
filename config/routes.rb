# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :search, only: :index

  root to: 'search#index'
end
