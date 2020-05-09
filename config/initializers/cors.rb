Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do

    origins Rails.application.config.allowed_cors_origins

    resource '*',
      headers: :any,
      credentials: true,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
