function Install-Gems
{
  cp -force Gemfile Gemfile.bak

  # Unbuildable on Windows
  sed -i '/sqlint/d' Gemfile
  # https://github.com/coala/coala-bears/issues/2909
  sed -i '/csvlint/d' Gemfile

  # pusher-client 0.4.0 doesnt depend on json, which requires
  # a compiler and the GMP library
  echo 'gem "pusher-client", "~>0.4.0", require: false' | Out-File -FilePath Gemfile -Append -Encoding ascii
  cat Gemfile

  bundle install

  mv -force Gemfile.bak Gemfile
}

function Do-Install-Packages
{
  Install-Gems
}
