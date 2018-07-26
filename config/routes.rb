Rails.application.routes.draw do
  get 'welcome_controller/index'
  root "welcome#index"
end
