Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['OMNIAUTH_GITHUB_KEY'], ENV['OMNIAUTH_GITHUB_SECRET']
end