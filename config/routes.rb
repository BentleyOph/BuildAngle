Rails.application.routes.draw do
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  root "website_requests#new"

  resources :website_requests, only: [ :new, :create ] do
    member do 
      get "generating"
      post "perform_generation"
      post "deploy"
  get "download"
    end
    resources :steps, only: [ :show, :update ], controller: "website_request_steps"
  end


  get "preview/:id/frame", to: "previews#frame", as: "website_preview_frame"
  get "previews/:id", to: "previews#show", as: "website_preview"
  get 'sites/:id/*page', to: 'previews#serve_page', as: 'serve_site_page'
  get 'sites/:id', to: 'previews#frame', as: 'preview_site'
end
