require 'fastlane/action'
require_relative '../helper/connected_helper'
require "app_store_connect"

module Fastlane
  module Actions
    class ConnectedAuthAction < Action
      def self.authenticate(api_key, key_id, issuer_id)
        AppStoreConnect.config = {
          issuer_id: issuer_id,
          key_id: key_id,
          private_key: api_key
        }
      end

      def self.run(params)
        api_key = params.values[:api_key]
        key_id = params.values[:key_id]
        issuer_id = params.values[:issuer_id]

        if api_key == '*'
          UI.message("Successfully Authenticated with App Store Connect!")
        end

        self.authenticate(api_key, key_id, issuer_id)
      end

      def self.description
        "App Store Connect API Plugin"
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
          FastlaneCore::ConfigItem.new(key: :api_key,
                                  env_name: "CONNECT_API_KEY",
                               description: "You app store connect api key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :key_id,
                                  env_name: "CONNECT_KEY_ID",
                               description: "You app store connect key id",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :issuer_id,
                                  env_name: "CONNECT_KEY_ISSUER_ID",
                               description: "You app store connect issuer id key",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
