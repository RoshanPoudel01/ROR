# This file is used to configure the Cross-Origin Resource Sharing (CORS) policy for the Rails application.
Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins "*"
      resource "*", headers: :any, methods: [ :get, :post, :patch, :put, :delete ]
    end
  end
