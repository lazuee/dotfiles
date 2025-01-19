$filePath = "$env:USERPROFILE\.config\komorebi\komorebi.json"

if (Test-Path $filePath) {
    $json = Get-Content -Path $filePath -Raw | ConvertFrom-Json
    $workspaces = $json.monitors | ForEach-Object { $_.workspaces.name }
    $rules = $json.named_workspace_rules

    if ($rules) {
        foreach ($rule in $rules) {
            $workspace = $rule.workspace
            if ($workspaces -notcontains $workspace) {
                Write-Warning "Workspace '$workspace' from named_workspace_rules does not exist in monitors."
            } else {
                $kind = $rule.kind.ToLower()
                $id = $rule.id
                $command = "komorebic named-workspace-rule $kind $id $workspace"
                Write-Host "Executing: $command"
                Invoke-Expression $command
                Start-Sleep 2
                komorebic retile
            }
        }
    } else {
        Write-Host "No named_workspace_rules found in the JSON file."
    }
} else {
    Write-Host "The file $filePath does not exist."
}
