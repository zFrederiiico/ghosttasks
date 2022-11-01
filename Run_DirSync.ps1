function DirSync(){

    Clear-Host
    Write-Host @"

    SINCRONIZANDO!!

"@
# Execução remota do Synchronization Service Manager
Invoke-Command -ComputerName SyncServer.local -ScriptBlock {& Start-ADSyncSyncCycle -PolicyType Delta } | Out-Null

Write-Host "DIRSYNC EXECUTADO COM SUCESSO!!"
pause
}