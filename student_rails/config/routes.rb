Rails.application.routes.draw do
  root "students#index"
  resources :students, only: %i[index show create update]
  resources :students do
    collection do
      post "delete_multiple", to: "students#delete_multiple"
    end
  end
  resources :labs, only: %i[index show create update destroy]
  resources :marks
end
