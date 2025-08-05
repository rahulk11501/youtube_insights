Rails.application.routes.draw do
  resources :channel_lookups, only: [:create, :show]
end
