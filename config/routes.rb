require "sidekiq/web"

Rails.application.routes.draw do
  authenticated :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :code_projects do
    resources :submissions, only: %i[new create], module: :code_projects
  end

  resource :ide, only: :show
  get "ide_internal/split_pass"
  post "ide_internal/send_code"

  resources :p5_file_inline, only: %i[show]

  # student routes

  namespace :student do
    resource :dashboard, only: %i[show]

    resources :courses, only: %i[index show] do
      scope module: :courses do
        resource :gradebook, only: :show
      end
    end

    resources :enrollments, only: %i[new create]

    resources :lab_file_groups, only: :show do
      resources :programming_lab_files, only: :show, module: :lab_file_groups
    end

    resources :programming_labs

    resources :course_programming_labs, only: %i[show] do
      scope module: :course_programming_labs do
        resources :submissions, only: %i[new create index show]
        resource :submission_from_ide, only: %i[new create]
      end
    end

    resources :submission_files, only: %i[show]
  end

  # teacher routes

  namespace :teacher do
    resource :dashboard, only: %i[show]

    resources :courses, only: %i[show new create edit update destroy] do
      scope module: :courses do
        resource :gradebook, only: %i[show]
      end
    end

    resources :course_programming_labs, only: %i[index show update] do
      resources :submissions, only: %i[index show edit update], module: :course_programming_labs
    end

    resources :lab_file_groups, only: %i[show] do
      resources :programming_lab_files, only: %i[show], module: :lab_file_groups
    end

    resources :programming_labs, only: %i[show] do
      resources :course_assignments, only: %i[new create], module: :programming_labs
    end

    resources :course_templates, only: %i[index show] do
      resource :courses, only: %i[new create], module: :course_templates
    end
  end

  # super_teacher routes

  namespace :super_teacher do
    resources :programming_labs, except: %i[destroy]
  end

  # admin routes

  namespace :admin do
    resource :dashboard, only: :show
    resources :programming_labs

    resources :courses do
      scope module: :courses do
        resources :programming_labs
      end
    end

    resources :users
    resources :lab_file_groups do
      resources :programming_lab_files, only: :show, module: :lab_file_groups
    end
  end

  root "pages#home"

  devise_for :users, controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    registrations: "users/registrations",
    sessions: "users/sessions",
    unlocks: "users/unlocks",
  }

  constraints subdomain: Rails.application.credentials.subdomain.fetch(:player).fetch(Rails.env.to_sym) do
    resource :player, only: :show
    resources :p5_file_inline, only: %i[show]
  end
end
