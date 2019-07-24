function Install-coala-java-bears {
    bash -e .ci/deps.coala-bears.sh
}

function Invoke-ExtraInstallation {
    Install-coala-java-bears
}
