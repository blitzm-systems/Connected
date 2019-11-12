require 'fastlane/action'
require_relative '../helper/connected_helper'
require "app_store_connect"
require "base64"
require 'plist'

module Fastlane
  module Actions
    class ConnectedCertsAction < Action
      def self.install_cert(certificate_path, certificate_name)
        sh("security", "import", certificate_path, "-k", File.expand_path("~/Library/Keychains/login.keychain-db"))
        UI.success("Successfully installed Certificate: #{certificate_name}")
      rescue StandardError => e
        if e.message.include?("already exists in the keychain.")
          UI.success("Certificate already exists in keychain: #{certificate_name}")
        else
          UI.message("Failed to install Certificate: #{certificate_name}")
          raise e
        end
      end

      def self.run(params)
        app_id = params.values[:app_id]

        if app_id == '*'
          UI.success("Successfully Downloaded Certificates!")
          return
        end

        app_store_connect = AppStoreConnect::Client.new

        # Get profiles for bundle id
        response = app_store_connect.profiles(
          include: 'bundleId',
          fields: {
            profiles: 'bundleId',
            bundle_ids: 'identifier'
          }
        )

        bundle_id = response['included']
                    .select { |i| i['type'] == 'bundleIds' }
                    .detect({}) { |i| i.dig('attributes', 'identifier') == app_id }

        profiles = response['data']
                   .select { |d| bundle_id['id'] == d.dig('relationships', 'bundleId', 'data', 'id') }

        # Install all provisioning profiles and certificates
        profiles.each do |profile|
          # Get provisioning profile file content
          profile_data = app_store_connect.profile(id: profile['id'])
          profile_name = profile_data['data']['attributes']['name'].gsub(/\s/, '')
          profile_content = Base64.decode64(profile_data['data']['attributes']['profileContent'])

          # Save provisioning profile to file
          directory = ".temp"
          Dir.mkdir(directory) unless File.exist?(directory)
          profile_path = File.join(directory, "#{profile_name}_#{profile['id']}.mobileprovision")
          out_file = File.new(profile_path, "w+")
          out_file.puts(profile_content)
          out_file.close

          # Install the profile
          UI.message("Installing Provisioning Profile: #{profile_name}")
          destination = File.join(ENV['HOME'], "Library/MobileDevice/Provisioning Profiles", "#{profile['id']}.mobileprovision")
          FileUtils.copy_file(profile_path, destination)
          UI.success("Succesfully Installed Profile: #{profile_name}")

          # Get certificates from profile
          readable_profile_path = "#{profile_path}.readable"
          sh("security cms -D -i #{profile_path} > #{readable_profile_path}")
          profile_plist = Plist.parse_xml(readable_profile_path)
          certificates = profile_plist["DeveloperCertificates"]

          # Install the certificates
          UI.message("Installing Certificates for Provisioning Profile: #{profile_name}")
          i = 1
          certificates.each do |certificate|
            certificate_name = "#{profile_name}_cert_#{i}.cer"
            certificate_path = File.join(directory, certificate_name)
            out_file = File.new(certificate_path, "w+")
            out_file.puts(certificate.string)
            out_file.close
            self.install_cert(certificate_path, certificate_name)
            i += 1
          end
        end
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
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
