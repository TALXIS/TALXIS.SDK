Class CDSPackage {
    [String] $Name
    [String] $ImportConfigPath

    [String] GetSolutionFileNames() {
        return Get-ImportConfigSolutions $this.ImportConfigPath
    }
}