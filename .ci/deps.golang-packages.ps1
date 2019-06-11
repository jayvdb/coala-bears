function Install-GoMetalinter-Linters
{
  $list = Get-ChildItem -Recurse $env:GOPATH | Out-String
  Write-Verbose ('go dir ' + $list)

  $gometalinter_install_cmd = ($env:GOPATH + '\bin\gometalinter.v2.exe --install')

  Invoke-Expression $gometalinter_install_cmd
}

function Do-Install-Packages
{
  Install-GoMetalinter-Linters

  go get -u github.com/BurntSushi/toml/cmd/tomlv
  go get -u sourcegraph.com/sqs/goreturns
}
