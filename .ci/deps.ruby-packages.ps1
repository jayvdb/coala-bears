function Install-Gems
{
  cp -force Gemfile Gemfile.bak

  # Unbuildable on Windows
  sed -i '/sqlint/d' Gemfile
  # https://github.com/coala/coala-bears/issues/2909
  sed -i '/csvlint/d' Gemfile

  # pusher-client 0.4.0 doesnt depend on json, which requires
  # a compiler and the GMP library
  echo 'gem "pusher-client", "~>0.4.0", require: false' >> Gemfile

  # The build crawls if DevKit is included in the PATH
  $old_PATH = $env:PATH
  $env:PATH = ($env:ChocolateyToolsLocation + '\DevKit2\bin;' + $env:PATH)

  bundle install

  $env:PATH = $old_PATH

  mv -force Gemfile.bak Gemfile
}

function Do-Install-Packages
{
  Install-Gems
}
