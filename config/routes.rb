Rails.application.routes.draw do
  resources :entries

  root 'welcome#index'

  get ':competition_id/:permalink' => 'competitions#entrant_page', constraints: {competition_id: /\d+/}
  put 'competitions/:competition_id' => 'competitions#update', constraints: {competition_id: /\d+/}

  post 'entries' => 'entries#create'

  get 'account-settings' => 'account_settings#edit', as: 'account_settings'
  put 'account-settings' => 'account_settings#update'

  get 'mailing-lists' => 'mailing_lists#index', as: 'mailing_lists'
end
