Fink::Engine.routes.draw do
  post 'reports', to: 'reports#create'
end
