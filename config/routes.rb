Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # Signup
  root 'sessions#new'
  scope '/signup' do
    get '/'  => 'users#new', as: :signup
    post '/'  => 'users#create'
  end
  # Login
  scope '/login' do
    get '/'  => 'sessions#new', as: :login
    get '/error'  => 'sessions#error'
    get '/error/passwd'  => 'sessions#newpass'
    get '/session'  => 'sessions#loggedout'
    post '/'  => 'sessions#create'
  end
  # Logout
  scope '/logout' do
    get '/' => 'sessions#destroy', as: :logout
  end
  # Dashboard
  scope '/dash' do
    get '/' => 'dashboard#new', as: :dash
  end
  scope '/zone' do
    get '/:id' => 'zone#index', as: :zone
  end
  # Admin
  scope '/admin' do
    get '/' => 'admin#new', as: :admin
    # Users
    scope '/users' do
      get '/' => 'admin#users', as: :admin_users
      get '/lock/:id' => 'admin#lock_account', as: :admin_lock_user
      get '/unlock/:id' => 'admin#unlock_account', as: :admin_unlock_user
      scope '/make' do
        get '/admin/:id' => 'admin#make_admin', as: :admin_create_admin
        get '/user/:id' => 'admin#make_user', as: :admin_create_user
      end
      post '/edit' => 'admin#edit_user', as: :admin_edit_users
    end
    # Servers
    scope '/servers' do
        get '/' => 'admin#servers', as: :admin_servers
        get '/destroy/:id' => 'admin#destroy', as: :admin_destroy_servers
    end
    scope '/templates' do
      get '/' => 'admin#templates', as: :admin_templates
      post '/edit' => 'admin#edit_template', as: :admin_edit_templates
      get '/destroy/:id' => 'admin#destroy_template', as: :admin_destroy_templates
      post '/create' => 'admin#create_template', as: :admin_create_templates
    end
    scope '/groups' do
      get '/' => 'admin#groups', as: :admin_groups
      post '/edit' => 'admin#edit_group', as: :admin_edit_groups
      get '/destroy/:id' => 'admin#destroy_group', as: :admin_destroy_groups
      post '/create' => 'admin#create_group', as: :admin_create_groups
    end
    scope '/support' do
      get '/' => 'admin#support', as: :admin_support
      get '/closed' => 'admin#closed_tickets', as: :admin_support_closed
      get '/close/:id' => 'admin#close_ticket', as: :admin_support_close
      get '/open/:id' => 'admin#open_ticket', as: :admin_support_open
      get '/view/:id' => 'admin#view_ticket', as: :admin_support_view
      post '/reply/:id' => 'admin#reply_ticket', as: :admin_support_reply
    end
    scope '/announcements' do
      get '/' => 'admin#announcements', as: :admin_announcements
      post '/create' => 'admin#create_announcement', as: :admin_announcements_create
      get '/destroy/:id' => 'admin#destroy_announcement', as: :admin_announcements_destroy
      post '/edit' => 'admin#edit_announcement', as: :admin_announcements_edit
    end
    scope '/zones' do
      get '/' => 'admin#zones', as: :admin_zones
      get '/destroy/:id' => 'admin#destroy_node', as: :admin_zones_destroy
      post '/add' => 'admin#add_zone', as: :admin_create_zones
      get '/delete/:id' => 'admin#destroy_zone', as: :admin_destroy_zones
    end
    scope '/pools' do
      get '/' => 'admin#pools', as: :admin_pools
      post '/create' => 'admin#create_pool', as: :admin_pools_create
      get '/destroy/:id' => 'admin#destroy_pool', as: :admin_pools_destroy
    end
    scope '/plans' do
      get '/' => 'admin#plans', as: :admin_plans
      post '/create' => 'admin#create_plan', as: :admin_plans_create
      get '/destroy/:id' => 'admin#destroy_plan', as: :admin_plans_destroy
    end
  end
  # Account
  scope '/account' do
    get '/' => 'account#new', as: :account
    post '/' => 'account#update'
    get '/saved' => 'account#updated', as: :account_saved
    get '/error' => 'account#error', as: :account_error
  end
  # Activity
  scope '/activity' do
    get '/' => 'activity#new', as: :activity
  end
  # Reset
  scope '/reset' do
    get '/' => 'reset#new', as: :reset
    post '/' => 'reset#check'
    get '/error' => 'reset#chgerror', as: :reset_error_reset
    get '/done' => 'reset#done', as: :reset_done
    get '/:id' => 'reset#reset'
    post '/:id' => 'reset#change', as: :reset_reset
  end
  # Verify
  scope '/verify' do
    get '/' => 'verify#new', as: :verify
    post '/' => 'verify#verify'
    get '/error' => 'verify#error', as: :verify_error
  end
  scope '/api' do
    scope '/v1' do
      get '/auth' => 'api#authenticate'
      post '/register' => 'api#registeruser'
      post '/verify' => 'api#verify'
      get '/reset' => 'api#reset'
      get '/details' => 'api#userdetails'
      patch '/password' => 'api#userpasswd'
      get '/tickets' => 'api#supporttickets'
      get '/bills' => 'api#showbills'
      get '/logs' => 'api#showlogs'
      patch '/style' => 'api#updatestyle'
      scope '/bill' do
        get '/:id' => 'api#viewbill'
      end
      scope '/ticket' do
        get '/:id' => 'api#viewticket'
        post '/create' => 'api#createticket'
      end
      get '/run_accounting' => 'api#run_accounting'
      get '/run_generation' => 'api#run_generation'
    end
  end
  scope '/create' do
    get '/' => 'zone#create', as: :new_zone
    post '/' => 'zone#make'
  end
  scope '/errors' do
    get '/400' => 'errors#e400'
    get '/401' => 'errors#e401'
    get '/403' => 'errors#e403'
    get '/404' => 'errors#e404'
    get '/405' => 'errors#e405'
    get '/406' => 'errors#e406'
    get '/422' => 'errors#e422'
    get '/500' => 'errors#e500'
    get '/501' => 'errors#e501'
  end
end
