# coding: utf-8

Rails.application.config.middleware.use OmniAuth::Builder do
  
  # provider :twitter,"Consumer key","Consumer secret"
  provider :facebook,"129550470552082", "6a185210a3ad8524b0f54bb8b50eed5d"
  
end