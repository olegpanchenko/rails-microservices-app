Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"  # Allow all origins (Not recommended for production)

    resource "*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: [ "Authorization" ]
  end
end
