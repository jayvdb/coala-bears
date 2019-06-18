$ci_directory = $env:FudgeCI

if (!($ci_directory))
{
  $ci_directory = '.ci'
}

. $ci_directory/constants.ps1

function Install-Binary-Packages
{
  # Install lxml needed by for coala-bears as a wheel as libxml2 and libxslt
  # headers and library files are not available, and STATIC_DEPS=true often
  # results in linter problems due to different VS compilers and MS runtimes.
  # Also use cffi wheel to avoid need for VS compilers
  python -m pip install --prefer-binary cffi lxml
  # pycparser not a wheel, but ensure it is installable before proceeding
  # https://github.com/eliben/pycparser/issues/251
  python -m pip --verbose install pycparser
  # pyrsistent->jsonschema->nbformat fails on old setuptools if no MS VC 9
  # https://github.com/tobgu/pyrsistent/issues/172
  # wrapt->astroid->pylint fails on old setuptools if no MS VC 9
  # https://github.com/GrahamDumpleton/wrapt/issues/135
  python -m pip install -U setuptools
  python -m pip install pyrsistent
}

function Install-coala-Packages
{
  python -m pip install -U six pip==$pip_version setuptools==$setuptools_version

  if ($name -eq 'coala-bears')
  {
    cp bear-requirements.txt constraints.txt
  }
  elseif (Test-Path 'requirements.txt')
  {
    cp requirements.txt constraints.txt
  }
  else
  {
    touch constraints.txt
  }

  if (!($name -eq 'PyPrint'))
  {
    echo "Installing PyPrint"
    {python @Args} | % Invoke @(
      '-m', 'pip', '--disable-pip-version-check', 'install',
      '--constraint', 'constraints.txt',
      'git+https://gitlab.com/coala/PyPrint#egg=PyPrint'
    )

    if (!($name -eq 'coala_utils'))
    {
      echo "Installing coala_utils"

      python -m pip freeze --all > constraints.txt

      {python @Args} | % Invoke @(
        '-m', 'pip', '--disable-pip-version-check', 'install',
        '--constraint', 'constraints.txt',
        'git+https://gitlab.com/coala/coala-utils#egg=coala-utils'
      )

      if (!($name -eq 'dependency-management'))
      {
        echo "Installing sarge with Windows support"

        {python @Args} | % Invoke @(
          '-m', 'pip', '--disable-pip-version-check', 'install',
          '--constraint', 'constraints.txt',
          'hg+https://bitbucket.org/jayvdb/sarge@win-reg-lookup#egg=sarge'
        )

        if (!(Test-Path $env:TEMP/pm-master))
        {
          $PM_URL = "https://gitlab.com/coala/package_manager.git/"
          git clone $PM_URL $env:TEMP/pm-master
        }
        rm $env:TEMP/pm-master/test-requirements.txt
        rm $env:TEMP/pm-master/requirements.txt
        touch $env:TEMP/pm-master/test-requirements.txt
        touch $env:TEMP/pm-master/requirements.txt

        {python @Args} | % Invoke @(
          '-m', 'pip', '--disable-pip-version-check', 'install',
          '--constraint', 'constraints.txt',
          "$env:TEMP/pm-master"
        )

        if (!($name -eq 'coala'))
        {
          echo "Installing coala"

          python -m pip freeze --all > constraints.txt

          {python @Args} | % Invoke @(
            '-m', 'pip', '--disable-pip-version-check', 'install',
            '--constraint', 'constraints.txt',
            'git+https://github.com/coala/coala#egg=coala'
          )

          if (!($name -eq 'coala-bears'))
          {
            echo "Installing coala-bears"

            python -m pip freeze --all > constraints.txt

            {python @Args} | % Invoke @(
              '-m', 'pip', '--disable-pip-version-check', 'install',
              '--constraint', 'constraints.txt',
              'git+https://github.com/coala/coala-bears#egg=coala-bears'
            )
          }
        }
      }
    }
  }

  if (Test-Path 'requirements.txt')
  {
    echo "Installing requirements.txt"
    {python @Args} | % Invoke @(
      '-m', 'pip', '--disable-pip-version-check', 'install',
      '--constraint', 'constraints.txt',
      '-r', 'requirements.txt'
    )
  }

  if (Test-Path 'setup.py')
  {
    echo "Installing setup.py"
    {python @Args} | % Invoke @(
      '-m', 'pip', '--disable-pip-version-check', 'install',
      '--constraint', 'constraints.txt',
      '-e', '.'
    )
  }
}

function Install-Test-Packages
{
  python -m pip freeze --all > constraints.txt

  echo "Installing test-requirements.txt"

  {python @Args} | % Invoke @(
    '-m', 'pip', '--disable-pip-version-check', 'install',
    '--constraint', 'constraints.txt',
    '-r', 'test-requirements.txt',
    'pytest-spec'
  )

  echo "Installing tox"

  if ($name -eq 'coala-bears')
  {
    python -m pip install -U setuptools

    python -m pip freeze --all > constraints.txt

    {python @Args} | % Invoke @(
      '-m', 'pip', '--disable-pip-version-check', 'install',
      '--constraint', 'constraints.txt',
      'tox', 'tox-backticks'
    )
  }
}

function Do-Install-Packages
{
  Install-Binary-Packages

  if (!($env:PYTHON_VERSION -eq '2.7'))
  {
    Install-coala-Packages
  }

  Install-Test-Packages
}
