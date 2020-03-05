![fastlane Plugin Badge](./readme_assets/logo.png)

# Connected Fastlane Plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-connected)

- This project was built and test using ruby version 2.5.5 and includes an rbenv configuration file for contributors

## About connected

A fastlane plugin which interacts with a 3rd party ruby App Store Connect sdk (https://github.com/kyledecot/app_store_connect).

This plugin is used for all interactions with the app store connect api except for uploading apps. This plugin uses `altool` (an XCode command line tool) and your app store connect api key to upload apps.

This plugin has [3 actions](lib/fastlane/plugin/connected/actions)

- **connected_auth**

  - Initialises app store connect api session
  - You MUST call execute this action before you can use any other actions

- **connected_certs**

  - Fetches all the provisioning profiles for a given app id and installs their certificates
  - Requires you to have create your provisioning profile for your app manually

- **connected_upload**

  - Uploads your `.ipa` file to TestFlight

Please post requests for new features for this plugin as it is still very barebones.

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-connected`, add it to your project by running:

```shell
fastlane add_plugin connected
```

I recommend setting up these env variable in your CI

```shell
# The content of your app store key .p8 file
CONNECT_API_KEY=""

# Your app store connect key id
CONNECT_KEY_ID=""

# Your app store connect key issuer id
CONNECT_KEY_ISSUER_ID=""
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

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
