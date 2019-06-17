function Install-Gems
{
  cp -force Gemfile Gemfile.bak

  # Unbuildable on Windows
  sed -i '/sqlint/d' Gemfile
  # https://github.com/coala/coala-bears/issues/2909
  sed -i '/csvlint/d' Gemfile

  bundle install
  mv -force Gemfile.bak Gemfile
}

function Do-Install-Packages
{
  Install-Gems
}
