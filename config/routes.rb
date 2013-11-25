Dingr::Application.routes.draw do

  resources :players, only: [:index, :create, :update]
  resources :tunes do
    member do
      post 'insert_rest'
    end

    resources :versions, only: [:show]
  end

  root to: 'players#index'

end
