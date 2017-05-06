# Liftracker iOS

The Liftracker iOS project is designed to provide low-cost data collection and easy abstractions for developers to create tools to improve working out.  This project aims to be an open way to share data processors for consumer use.

Due to the sensitive nature of the data, any extensions added must be approved by the maintainer via pull request.  This is to enforce the strict no-upload policy of the environment.


# Setting up

This project uses Cocoapods to manage dependencies, and Jazzy to generate it's documentation.

To configure your local environment the "default" way, run `./Tools/setup.sh` in the root of the project. This will configure ruby to use bundler, install the required gems, and update your xcode using [xcode-install](https://github.com/KrauseFx/xcode-install). Note that if an update (or reinstall through xcode-install) is required it can take quite a while for this script to complete.

If you want to manage your development environment manually, ensure that you've installed the gems listed in the `Gemfile` and that your XCode version is 8.3.2 or newer.
