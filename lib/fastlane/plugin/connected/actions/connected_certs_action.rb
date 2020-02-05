require 'fastlane/action'
require_relative '../helper/connected_helper'
require "app_store_connect"

module Fastlane
  module Actions
    class ConnectedCertsAction < Action
      def self.run(params)
        app_id = params.values[:app_id]

        if app_id == '*'
          UI.success("Successfully Downloaded Certificates!")
          return
        end
        app_store_connect = AppStoreConnect::Client.new

        # Download profiles
        UI.message("Downloading Provisioning Profiles for app: #{app_id}")
        profiles = Helper::CertsHelper.download_provisioning_profiles_for_app(app_store_connect, app_id)

        # Install profiles and profile certificates
        profiles.each do |profile|
          profile_name = profile['name']

          UI.message("Installing Provisioning Profile: #{profile_name}")
          installed_profile = Helper::CertsHelper.install_provisioning_profile(app_store_connect, profile)
          UI.success("Succesfully Installed Provisioning Profile: #{profile_name}")

          UI.message("Installing Certificates from Provisioning Profile: #{profile_name}")
          Helper::CertsHelper.install_certificates_from_provisioning_profile(app_store_connect, installed_profile)
          UI.success("Successfully Installed Certificates for Provisioning Profile: #{profile_name}\n")
        end

        UI.success("Action connected_certs completed successfully!")
      end

      def self.description
        "App Store Connect API Certificates Module"
      end

      def self.authors
        ["Abgier Avraha"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :app_id,
                               description: "You app's bundle identifier",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:ios].include?(platform)
      end
    end
  end
end
