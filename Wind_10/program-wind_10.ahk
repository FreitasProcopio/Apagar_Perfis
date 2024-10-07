#Persistent
#NoEnv
#SingleInstance, Force
SendMode Input

Confirm() {
    MsgBox, 4, Confirmação, Tem certeza que deseja excluir os usuários não críticos?
    IfMsgBox Yes
        Return 1
    Else
        Return 0
}

RunAsAdmin(command) {
    shell := ComObjCreate("Shell.Application")
    shell.ShellExecute("powershell.exe", "-Command " . command, "", "runas", 1)
}

if (Confirm()) {
    ; Comando para remover usuários não críticos
    command := "
    (
        $users = Get-LocalUser | Where-Object { $_.Name -notin @('Administrador', 'Convidado', 'DefaultAccount', 'gaia', 'supor', 'WDAGUtilityAccount') }
        foreach ($user in $users) {
            Remove-LocalUser -Name $user.Name
        }
    )"
    
    ; Comando para remover diretórios específicos
    command .= "
    (
        $dirs = @('C:\Users\*_*', 'C:\Users\estagio*')
        foreach ($dir in $dirs) {
            Get-ChildItem -Path $dir -Directory | Remove-Item -Force -Recurse
        }
    )"

} else {
    MsgBox, Operação Cancelada.
    ExitApp
}

RunAsAdmin(command)
ExitApp
