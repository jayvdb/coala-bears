function PPM-Install-cpanm
{
  ppm install App-cpanminus
}

function Do-PostInstall
{
  PPM-Install-cpanm
}

Export-ModuleMember -Function PPM-Install-cpanm, Do-PostInstall
