![fastlane Plugin Badge](./readme_assets/logo.png)

# Connected Fastlane Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-connected)

## About connected

A fastlane plugin that uses your app store connect api key to upload apps to TestFlight and install provisioning profiles. This plugin interacts with a 3rd party ruby App Store Connect sdk (https://github.com/kyledecot/app_store_connect).

This plugin has [3 actions](lib/fastlane/plugin/connected/actions)

- **connected_auth**

  - Initialises app store connect api session
  - You MUST execute this action before you can use any other actions
  - Example (requires CONNECT_API_KEY, CONNECT_KEY_ID and CONNECT_KEY_ISSUER_ID in your env variables)
    ```ruby
    connected_auth
    ```

- **connected_certs**

  - Fetches all of the provisioning profiles for a given app id, installs them and their certificates
  - Requires you to have created your provisioning profile for your app manually in the Apple Developer Portal
  - Example
    ```ruby
    connected_certs(
      app_id: 'com.company.app'
    )
    ```

- **connected_upload**

  - Uploads your `.ipa` file to TestFlight
  - Example if you used gym to compile your app
    ```ruby
    connected_upload(
      ipa_file: lane_context[SharedValues::IPA_OUTPUT_PATH]
    )
    ```

* Please post requests for new features for this plugin as it is still very barebones.

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-connected`, add it to your project by running:

```shell
fastlane add_plugin connected
```

You should setup these env variable in your CI machine. If you don't have these credentials, you can follow this documentation https://developer.apple.com/documentation/appstoreconnectapi/creating_api_keys_for_app_store_connect_api

```shell
# The content of your app store key .p8 file
CONNECT_API_KEY=""
export CONNECT_API_KEY="-----BEGIN PRIVATE KEY-----
5ED67D7564A5387EE418844C7A8E85ED67D7564A5387EE418844C7A8E85ED67D
5ED67D7564A5387EE418844C7A8E85ED67D7564A5387EE418844C7A8E85ED67D
5ED67D7564A5387EE418844C7A8E85ED67D7564A5387EE418844C7A8E85ED67D
5ED67D75
-----END PRIVATE KEY-----"

# Your app store connect key id
export CONNECT_KEY_ID="5ED67D7564"

# Your app store connect key issuer id
export CONNECT_KEY_ISSUER_ID="fj83hofh-fj83-fj83-f83j-fj83hofh92b5"
```

## Example

[Check out the example `Fastfile` to see how to use this plugin](fastlane/Fastfile). Try it by cloning the repo, running `bundle install` and `bundle exec fastlane test`.

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use

```
rubocop -a
```

- This project was built and test using ruby version 2.5.5 and includes an rbenv configuration file for contributors

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
