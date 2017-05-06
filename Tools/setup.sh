# Configure to use bundler, avoid tampering with the local ruby setup
gem install bundler
bundle install
# Update to the newest xcode
# xcodeVersion="$(bundle exec xcversion list | tail -1)"
# bundle exec xcversion install $xcodeVersion
