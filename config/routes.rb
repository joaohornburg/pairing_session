Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resource 'url', only: [:create] do
    get 'u/:shortened', to: 'urls#show'
    get '/', to: 'urls#index'
  end
end
