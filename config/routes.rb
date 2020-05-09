  Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :cities
      scope ":location", location: /almaty|astana|atyrau/ do
        resources :branches, only: :index
        root 'pages#home'
        post 'signin', controller: :signin, action: :create
        post 'signup', controller: :signup, action: :create
        delete 'signin', controller: :signin, action: :destroy
        get 'me', controller: :users, action: :me
        post 'send_request', controller: :requests, action: :create
        post 'send_subscription', controller: :subscriptions, action: :create
        get 'notifications/index'
        get 'courses', controller: :courses, action: :index
        get 'enrollments', controller: :enrollments, action: :index

        resources :courses do
          post 'reset_slug', on: :member
        end

        resources :password_resets, only: [:create] do
          collection do
            get ':token', action: :edit, as: :edit
            patch ':token', action: :update
          end
        end

        namespace :admin do
          resources :branches
          get 'dashboard', to: 'dashboard#index'
          post 'user/new', controller: :users, action: :create
          post 'groups/new', controller: :groups, action: :create
          post 'courses/new', controller: :courses, action: :create
          post 'enrollments/new', controller: :enrollments, action: :create
          post 'salaries/new', controller: :salaries, action: :create
          post 'payments/new', controller: :payments, action: :create
          get 'users/profile/:id', controller: :users, action: :show
          put 'users/profile/:id', controller: :users, action: :update
          post 'costs/new', controller: :costs, action: :create
          # get 'users/status', controller: :enrollments, action: :paid_days
          post 'courses/new', controller: :courses, action: :create
          post 'todos/new', controller: :todos, action: :create
          post 'branches/new', controller: :branches, action: :create
          post 'program/new', controller: :program, action: :create

          resources :groups do
            post 'reset_slug', on: :member
            resources :enrollments, shallow: true do
              resources :payments, shallow: true, except: :index
            end
          end
          resources :enrollments
          get 'users/instructors', controller: :users, action: :instructors
          resources :users, only: [:index, :show, :update, :create, :new, :destroy] do
          end
          resources :instructors
          resources :requests
          resources :courses do
            post 'reset_slug', on: :member
          end
          resources :schedule
          resources :payments
          resources :salaries
          resources :costs
          resources :notifications
          resources :todos
          resources :subscriptions
          resources :program
        end

        namespace :instructor do
          get 'dashboard', to: 'dashboard#index'
          put 'groups/coins/add', controller: :groups, action: :add_coins
          put 'attendance/new', controller: :attendances, action: :create
          resources :groups
          resources :users, only: [:index,:show,:edit]
          resources :teaching_hours
          resources :attendances, only: [:show, :update, :destroy]
          # resourses :items
          post 'teaching_hours/new', controller: :teaching_hours, action: :create
          post 'groups/create_item', controller: :groups, action: :create_item
        end

        namespace :student do
          get 'dashboard', to: 'dashboard#index'
          put 'groups/coins/add', controller: :groups, action: :add_coins
          put 'groups/coins/minus', controller: :groups, action: :minus_coins
          resources :groups
        end
        
        namespace :manager do
          get 'dashboard', to: 'dashboard#index'
          post 'user/new', controller: :users, action: :create
          post 'groups/new', controller: :groups, action: :create
          post 'enrollments/new', controller: :enrollments, action: :create
          post 'salaries/new', controller: :salaries, action: :create
          get 'users/profile/:id', controller: :users, action: :show
          put 'users/profile/:id', controller: :users, action: :update
          post 'courses/new', controller: :courses, action: :create
          post 'todos/new', controller: :todos, action: :create


          resources :groups do
            post 'reset_slug', on: :member
            resources :enrollments, shallow: true do
              resources :payments, shallow: true, except: :index
            end
          end
          resources :enrollments
          get 'users/instructors', controller: :users, action: :instructors
          resources :users, only: [:index, :show, :update, :create, :new] do
          end
          resources :instructors
          resources :requests
          resources :courses
          resources :payments
          resources :salaries
          resources :todos
        end
      end
      post 'refresh', controller: :refresh, action: :create
    end
  end
  mount ActionCable.server => '/cable'
end
