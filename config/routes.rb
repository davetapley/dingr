Dingr::Application.routes.draw do

  resources :players, only: [:index, :create, :update]

  root to: 'players#index'

end
