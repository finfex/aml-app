# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options Settings.default_url_options.symbolize_keys

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  get 'login' => 'user_sessions#new', as: :login
  delete 'logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: %i[new create destroy]

  resources :password_resets, only: %i[new create edit update]
  resource :password, only: %i[edit update]

  resources :operators, except: %i[show destroy] do
    member do
      put :block
      put :unblock
    end
  end

  scope module: :aml do
    concern :archivable do
      member do
        delete :archive
        post :restore
      end
    end

    resources :document_kinds, only: %i[index new create show] do
      concerns :archivable
    end
    resources :document_groups, only: %i[index new create show] do
      concerns :archivable
    end
    resources :document_kind_field_definitions, only: %i[new create edit update] do
      concerns :archivable
    end
    resources :clients, except: %i[edit update destroy]
    resources :orders do
      member do
        put :in_process
        put :accept
        put :reject
        put :stop
      end
    end
    resources :client_document_fields, only: %i[edit update]
    resources :order_documents, only: %i[show index new create] do
      member do
        put :accept
        put :reject
      end
    end
  end
end
