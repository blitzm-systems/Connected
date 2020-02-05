require 'fastlane/action'
require_relative '../helper/connected_helper'
require "app_store_connect"

module Fastlane
  module Actions
    class ConnectedUploadAction < Action
      def self.run(params)
        xcode_path = params.values[:xcode_dir]
        ipa_file = params.values[:ipa_file]
        api_key = params.values[:api_key]
        issuer_id = params.values[:issuer_id]
        key_id = params.values[:key_id]

        if ipa_file == '*'
          UI.success("Successfully Uploaded IPA File!")
          return
        end

        # Check that ipa file exists
        unless File.exist?(ipa_file)
          UI.error("Could not find ipa file in #{File.expand_path(ipa_file)}")
          UI.error("You can change the path to a different ipa file using the ipa_file command or IPA_FILE env variable")
          raise 'Connected Fastlane plugin failed to find your ipa file'
        end

        # Check for xcode installation
        unless File.exist?(xcode_path)
          UI.error("Could not find XCode in #{File.expand_path(xcode_path)}")
          UI.error("You can change the path to a different xcode installation using the xcode_dir command or DEVELOPER_DIR env variable")
          raise 'Connected Fastlane plugin failed to find your xcode installation'
        end

        # Save auth key to file
        connect_keys_dir = "#{ENV['HOME']}/.appstoreconnect"
        Dir.mkdir(connect_keys_dir) unless File.exist?(connect_keys_dir)
        key_dir = "#{connect_keys_dir}/private_keys"
        Dir.mkdir(key_dir) unless File.exist?(key_dir)

        key_path = "#{key_dir}/AuthKey_#{key_id}.p8"
        out_file = File.new(key_path, "w+")
        out_file.puts(api_key)
        out_file.close

        # Start upload
        altool_path = "#{xcode_path}/Contents/Developer/usr/bin/altool"
        sh("#{altool_path} --upload-app --type ios --file #{ipa_file} --apiKey #{key_id} --apiIssuer #{issuer_id}")

        UI.success("Successfully Uploaded IPA File!")
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
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :xcode_dir,
                                  env_name: "DEVELOPER_DIR",
                               description: "The path to your xcode directory",
                             default_value: "/Applications/Xcode.app",
                                  optional: true,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :api_key,
                                  env_name: "CONNECT_API_KEY",
                                description: "You app store connect api key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :issuer_id,
                                  env_name: "CONNECT_KEY_ISSUER_ID",
                                description: "You app store connect issuer id key",
                                  optional: false,
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :key_id,
                                  env_name: "CONNECT_KEY_ID",
                                description: "You app store connect key id",
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
