Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '388008365638-id4fiuf0518qi3np6kdld00cf906u8qd.apps.googleusercontent.com', 'mNGBdDmy8QL-Mb0rsOKgWkRk', {client_options: {ssl: {ca_file: Rails.root.join('lib/assets/cacert.pem').to_s}}}
end