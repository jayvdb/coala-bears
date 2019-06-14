function Install-Gems
{
  cp -force Gemfile Gemfile.bak
  # sed -i '/sqlint/d' Gemfile
  bundle install
  mv -force Gemfile.bak Gemfile
}

function Do-Install-Packages
{
  Install-Gems
}
