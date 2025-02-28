Rails.application.routes.draw do
  root "api/v1/lines#search"

  namespace :api do
    namespace :v1 do
      resources :lines, only: [:index, :show] do
        collection do
          get "search"
        end
      end
    end
  end
end
