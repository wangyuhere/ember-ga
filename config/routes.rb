Rails.application.routes.draw do
  root 'home#index'
  get '*pages', to: 'home#index'
end
