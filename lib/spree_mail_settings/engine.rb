module SpreeMailSettings
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_mail_settings'

    initializer 'loading decorators', after: :load_config_initializers do |_app|
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    initializer 'spree_mail_settings' do
      ActionMailer::Base.add_delivery_method :spree, Spree::Core::MailMethod
      Spree::Core::MailSettings.init
      Mail.register_interceptor(Spree::Core::MailInterceptor)
    end
  end
end
