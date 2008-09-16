# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1.0' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_record ]
  
  config.time_zone = 'UTC'
  
  config.action_controller.session = {
    :session_key => '_dugdale_session',
    :secret      => '6744a21bead584cf5e7ac92dd940a683fa238ff1429e1e811e6d0fee05a8ef0cca2a229ccd2ef167f6573d1d84cd424429fdb15c0a7de55737e1f94308c9bf8c'
  }
  
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/*"].map do |dir|
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
end
