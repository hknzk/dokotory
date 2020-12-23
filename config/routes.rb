Rails.application.routes.draw do

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # root to: "home#top"
  root to: 'home#top'
  post 'j_sample', to: 'home#j_sample'

  controller :sessions do
    get :login, action: :new
    post :login, action: :create
    delete :logout, action: :destroy
  end

  scope path: :home, as: :home, controller: :home do
    get '', action: :top
  end

  scope path: :admin, as: :admin, controller: :admin do
    get '', action: :top

  end

  scope path: :mypage, as: :mypage, controller: :mypage do
    get '', action: :top

    get :posted_articles
    get :draft_articles
    get :articles_in_progress
    get :favorites
    get :received_messages
    get :send_messages
    get :notifications
  end

  resources :articles do
    get :visitor, on: :member, action: :visitor
    get :map, param: :prefecture, on: :collection, action: :map
    post :load_detail, on: :collection, action: :load_detail
    resources :comments, only: [:create, :destroy]
    resources :favorites, only: [:create, :destroy]
  end

  resources :users do
    get :edit_profile, on: :member, action: :edit_profile
    get :posted_articles, on: :member, action: :posted_articles
    resources :messages, except: [:index, :edit]
  end

end
