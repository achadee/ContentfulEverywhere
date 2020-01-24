Rails.application.routes.draw do
  root 'welcome#index'

  # a hack so I dont have to write JS and can use HTML forms :^)
  match 'delete_data' => 'entries#destroy', :via => :post

  # entries resource
  resources :entries
end
