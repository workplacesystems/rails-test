Rails.application.routes.draw do
  resources :sales, except: [:index, :update]
end
