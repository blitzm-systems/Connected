require 'fastlane/action'
require_relative '../helper/connected_helper'
require "app_store_connect"

module Fastlane
  module Actions
    class ConnectedUploadAction < Action
      def self.run(params)
        ipa_file = params.values[:ipa_file]

        if ipa_file == '*'
          UI.success("Successfully Uploaded IPA File!")
          return
        end
      end

      def self.description
        "App Store Connect API Uploader Module"
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
          FastlaneCore::ConfigItem.new(key: :ipa_file,
                                  env_name: "IPA_FILE",
                               description: "The path to your compiled .ipa file",
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
