module RailsBase
  module Controllers
    module OmniAuthHelper
      def facebook
        callback_from :facebook
      end

      def twitter
        callback_from :twitter
      end

      private
      def callback_from(provider)
        provider = provider.to_s
        @instance = omni_auth_model_class.find_for_oauth(request.env['omniauth.auth'])
        if @instance.persisted?
          flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
          sign_in_and_redirect @instance, event: :authentication
        else
          if provider == 'twitter'
            session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
          else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
          end
          redirect_to failure_path
        end
      end

      # User以外にしたい場合はinclude元でオーバーライド
      def omni_auth_model_class
        User
      end

      # root以外にしたい場合はinclude元でオーバーライド
      def failure_path
        root_path
      end
    end
  end
end
