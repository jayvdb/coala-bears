ECHO FIRST LINE

ECHO %APPVEYOR_BUILD_WORKER_IMAGE% %PLATFORM%

ECHO %VS2017_VC% %WIN71_SDK_ROOT% %VS14_VC%

IF "%APPVEYOR_BUILD_WORKER_IMAGE%" == "Visual Studio 2015" (
  ECHO Setting up VS2015 %PLATFORM%

  IF %PLATFORM% == x64 (
    call "%WIN71_SDK_ROOT%\Bin\SetEnv.cmd" /x64

    call "%VS14_VC%\vcvarsall.bat" x86_amd64
  )
  IF %PLATFORM% == x86 (
    call "%VS14_VC%\vcvarsall.bat" x86
  )
)
IF "%APPVEYOR_BUILD_WORKER_IMAGE%" == "Visual Studio 2017" (
  ECHO Setting up VS2017 %PLATFORM% for image %APPVEYOR_BUILD_WORKER_IMAGE%

  IF %PLATFORM% == x64 (
    call "%VS2017_VC%\Auxiliary\Build\vcvars64.bat"
  )

  IF %PLATFORM% == x86 (
    call "%VS2017_VC%\Auxiliary\Build\vcvars32.bat"
  )
)
