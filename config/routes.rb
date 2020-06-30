CloudPrivateApi::Application.routes.draw do
  # Rotas publicas de cloud
  namespace "api" do
    namespace "v1" do
      resources :servers, only: %i[index show]
    end
  end
end
