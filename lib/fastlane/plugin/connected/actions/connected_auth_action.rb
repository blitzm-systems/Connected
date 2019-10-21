require 'fastlane/action'
require_relative '../helper/connected_helper'

module Fastlane
  module Actions
    class ConnectedAuthAction < Action
      def self.run(params)
        UI.message(params.values[:auth_key])
        UI.message("The connected plugin is working!")
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
          FastlaneCore::ConfigItem.new(key: :auth_key,
                                  env_name: "CONNECT_AUTH_KEY",
                               description: "You app store connect auth key",
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
