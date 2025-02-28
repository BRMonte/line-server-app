Rails.application.routes.draw do
  root "api/v1/lines#index"

  namespace :api do
    namespace :v1 do
      resources :lines, only: [:index, :show]
    end
  end
end
