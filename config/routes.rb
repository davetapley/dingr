Dingr::Application.routes.draw do

  resources :players, only: [:index, :create, :update]
  resources :tunes, only: [:index]

  root to: 'players#index'

end
