Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    member do
      get :cards_count
    end
  end

  resources :cards, except: %i[ index ] do
    member do
      patch :toggle_done
      patch :move
    end
  end

  resources :boards do
    member do
      get "lists", to: "boards#lists_json", defaults: { format: :json }
    end

    resources :lists, except: %i[ show index ] do
      member do
        get :cards_count
      end

      resources :cards, except: %i[ index ] do
        member do
          patch :toggle_done
          patch :move
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "boards#index"
end
