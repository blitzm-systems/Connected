require 'fastlane_core/ui/ui'
require "base64"
require 'plist'
require 'open3'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class CertsHelper
      # class methods that you define here become available in your action
      # as `Helper::CertsHelper.your_method`
      #
      def self.download_provisioning_profiles_for_app(app_store_connect, app_id)
        # Get profiles for bundle id
        response = app_store_connect.profiles(
          include: 'bundleId',
          fields: {
            profiles: 'bundleId',
            bundle_ids: 'identifier'
          }
        )

        unless response['errors'].nil?
          response['errors'].each do |e|
            UI.error("ERROR: #{e['title']} - #{e['detail']}")
          end
          raise "Connected Fastlane plugin couldn't fetch your certificates"
        end

        bundle_id = response['included']
                    .select { |i| i['type'] == 'bundleIds' }
                    .detect({}) { |i| i.dig('attributes', 'identifier') == app_id }

        profiles_shallow = response['data']
                           .select { |d| bundle_id['id'] == d.dig('relationships', 'bundleId', 'data', 'id') }

        profiles = []
        profiles_shallow.each do |p|
          profile_data = app_store_connect.profile(id: p['id'])
          profiles.push(profile_data)
        end

        return profiles
      end

      def self.install_provisioning_profile(app_store_connect, profile)
        # Get provisioning profile file content
        profile_name = profile['data']['attributes']['name'].gsub(/\s/, '')
        profile_content = Base64.decode64(profile['data']['attributes']['profileContent'])

        # Save provisioning profile to file
        directory = ".temp"
        Dir.mkdir(directory) unless File.exist?(directory)
        profile_path = File.join(directory, "#{profile_name}_#{profile['id']}.mobileprovision")
        out_file = File.new(profile_path, "w+")
        out_file.puts(profile_content)
        out_file.close

        # Install the profile
        destination = File.join(ENV['HOME'], "Library/MobileDevice/Provisioning Profiles", "#{profile['id']}.mobileprovision")
        FileUtils.copy_file(profile_path, destination)

        return { 'name' => profile_name, 'path' => profile_path }
      end

      def self.install_certificates_from_provisioning_profile(app_store_connect, installed_profile)
        profile_name = installed_profile['name']
        profile_path = installed_profile['path']

        # Get certificates from profile
        readable_profile_path = "#{profile_path}.readable"
        _stdout, stderr, _status = Open3.capture3("security cms -D -i #{profile_path} > #{readable_profile_path}")
        if stderr.length > 0
          UI.message("Failed to parse certificate")
          raise stderr
        end
        profile_plist = Plist.parse_xml(readable_profile_path)
        certificates = profile_plist["DeveloperCertificates"]

        directory = ".temp"
        i = 1
        certificates.each do |certificate|
          certificate_name = "#{profile_name}_cert_#{i}.cer"
          certificate_path = File.join(directory, certificate_name)
          out_file = File.new(certificate_path, "w+")
          out_file.puts(certificate.string)
          out_file.close
          self.install_certificate(certificate_path)
          i += 1
        end
      end

      def self.install_certificate(certificate_path)
        certificate_name = File.basename(certificate_path)
        _stdout, stderr, _status = Open3.capture3("security", "import", certificate_path, "-k", File.expand_path("~/Library/Keychains/login.keychain-db"))

        if stderr.length > 0
          if stderr.include?("already exists in the keychain.")
            UI.message("Certificate already exists in keychain: #{certificate_name}")
          else
            UI.error("Failed to install Certificate: #{certificate_name}")
            raise stderr
          end
        end
      end
    end

    class UploadHelper
      def self.upload_app(ipa_file, api_key, issuer_id, key_id, xcode_path)
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
        _stdout, stderr, _status = Open3.capture3("#{altool_path} --upload-app --type ios --file #{ipa_file} --apiKey #{key_id} --apiIssuer #{issuer_id}")
        if stderr.length > 0
          UI.message("Failed to upload .ipa file")
          raise stderr
        end
      end
    end
  end
end
