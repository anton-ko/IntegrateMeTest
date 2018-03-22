Rails.application.routes.draw do
  resources :entries

  root 'welcome#index'

  get ':competition_id/:permalink' => 'competitions#entrant_page', constraints: {competition_id: /\d+/}
  post 'entries' => 'entries#create'

  get 'account_settings' => 'account_settings#edit'
  put 'account_settings' => 'account_settings#update'
end
