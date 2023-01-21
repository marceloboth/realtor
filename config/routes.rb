# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :dashboard, only: :index

  root to: 'dashboard#index'
end
