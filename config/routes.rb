Dingr::Application.routes.draw do

  resources :players, only: [:index, :create, :update]
  resources :tunes, only: [:index, :show]

  root to: 'players#index'

end
