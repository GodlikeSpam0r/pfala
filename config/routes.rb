Rails.application.routes.draw do

  root :to => 'home#index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :users

  match 'camp', :to => 'camp#camp', :via => :get
  match 'camp/:id', :to => 'camp#show', :via => :get
  match 'camp/:id/edit', :to => 'camp#edit', :via => :post
  match 'camp/:id/useradd', :to => 'camp#add_user', :via => :post
  match 'camp/:id/userdel/:user', :to => 'camp#del_user', :via => :post
  match 'camp/add', :to => 'camp#add', :via => :post
  match 'camp/:id/picasso', :to => 'picasso#show', :via => :get
  match 'camp/:id/picasso/block', :to => 'picasso#block', :via => :get
  match 'camp/:id/picasso/block/add', :to => 'picasso#add_block', :via => :post
  match 'camp/:id/picasso/block/:block/update', :to => 'picasso#update_block', :via => :post
  match 'camp/:id/blocktypes', :to => 'camp#block_type', :via => :get
  match 'camp/:id/blocktypes/add', :to => 'camp#add_block_type', :via => :post
  match 'camp/:id/blocktypes/del/:block', :to => 'camp#del_block_type', :via => :post
  match 'camp/:id/blocktypes/edit/:block', :to => 'camp#edit_block_type', :via => :post
  match 'camp/:id/blocktypes/edit/:block', :to => 'camp#edit_block_type_show', :via => :get
  match 'users', :to => 'users#show', :via => :get
  match 'users/:id', :to => 'users#show', :via => :get
end
