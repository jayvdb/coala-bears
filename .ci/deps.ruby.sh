# Remove Ruby directive from Gemfile as we test many versions
sed -i.bak '/^ruby/d' Gemfile

gem update --system

gem install bundler
