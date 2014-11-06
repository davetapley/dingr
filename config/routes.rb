Dingr::Application.routes.draw do

  resources :players, only: [:index, :create, :update]
  resources :tunes do
    resources :versions, only: [:show]
  end

  root to: 'tunes#index'

end
