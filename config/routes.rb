Rails.application.routes.draw do
  root 'dashboard#index'

  constraints format: :json do
    resources :boards, shallow: true do
      resources :tasks do
        member do
          put :complete
        end
      end
    end
  end
end
