@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @(
        'PSAvoidUsingCmdletAliases',
        'PSUseApprovedVerbs',
        # 'unused' vars; in upstream and local code
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSAvoidUsingWriteHost'
    )
}
