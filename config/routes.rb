Rails.application.routes.draw do
  root 'dashboard#index'

  constraints format: :json do
    resources :boards, shallow: true, except: %i(new edit) do
      resources :tasks, except: %i(new edit) do
        member do
          put :complete
        end
      end
    end
  end
end
