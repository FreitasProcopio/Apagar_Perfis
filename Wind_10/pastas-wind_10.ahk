#Persistent
#NoEnv
#SingleInstance, Force
SendMode Input


RunAsAdmin(command) {
    shell := ComObjCreate("Shell.Application")
    shell.ShellExecute("powershell.exe", "-Command " . command, "", "runas", 1)
}


Confirm() {
    MsgBox, 4, Confirmação, Tem certeza que deseja excluir os usuários não críticos?
    IfMsgBox Yes
        return 1
    else
        return 0
}

if (Confirm()) {

command := "
(
    ; Remover diretórios que correspondem aos padrões especificados
    Loop, C:\Users\*_*, D
    {
        FileRemoveDir, %A_LoopFileFullPath%, 1
    }
    Loop, C:\Users\estagio*, D
    {
        FileRemoveDir, %A_LoopFileFullPath%, 1
    }
)"

} else {
    MsgBox, Operação Cancelada.
}
