module RailsBase::ActiveRecord
  module OmniauthHelper
    extend ActiveSupport::Concern

    module ClassMethods
      def find_for_oauth(auth)
        instance = self.where(uid: auth.uid, provider: auth.provider).first
        unless instance
          instance = self.new(
            uid: auth.uid,
            provider: auth.provider,
            name: auth.info.name,
            email: self.get_email(auth),
            password: Devise.friendly_token[4, 30])
          instance.skip_confirmation! if instance.attributes.keys.include?("confirmed_at")
          instance.profile_image_path =  auth.info.image if instance.attributes.keys.include?("profile_image_path") && auth.info.image
          instance.profile = auth.info.description if instance.attributes.keys.include?("profile") && auth.info.description
          instance.save
        end
        instance
      end

      def get_email(auth)
        email = auth.info.email
        email = "#{auth.provider}-#{auth.uid}@example.com" if email.blank?
        email
      end
    end
  end
end
