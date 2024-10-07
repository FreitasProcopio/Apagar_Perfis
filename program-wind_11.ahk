Persistent
#Requires Autohotkey v2.0
#SingleInstance Force
SendMode("Input")

Confirm() {
    ; Mostrar a caixa de mensagem e capturar o resultado diretamente
    result := MsgBox("Tem certeza que deseja excluir os usuários não críticos?", "Confirmação", 4)
    ; 6 corresponde ao botão 'Yes' e 7 corresponde ao botão 'No'
    return result
}

RunAsAdmin(command) {
    shell := ComObject("Shell.Application")
    shell.ShellExecute("powershell.exe", "-Command " . command, "", "runas", 1)
}

if (Confirm()) {
    ; Definindo o script PowerShell
    command := 
    "$dirs = @('C:\\Users\\*_*','C:\\Users\\estagio*')`n" . 
    "foreach ($dir in $dirs) {`n" .
    "    Get-ChildItem -Path $dir -Directory | ForEach-Object {`n" .
    "        try {`n" .
    "            Remove-Item -Path $_.FullName -Recurse -Force`n" .
    "        } catch {`n" .
    "            Write-Host 'Não foi possível remover: ' + $_.FullName + ' - ' + $_.Exception.Message`n" .
    "        }`n" .
    "    }`n" .
    "} `n" .
    "$appDataDirs = @('C:\\Users\\*\\AppData')`n" . 
    "foreach ($appDataDir in $appDatadirs) {`n" .
    "    Get-ChildItem -Path $dir -Directory | ForEach-Object {`n" .
    "    $appDataPath = Join-Path -Path $_.FullName -ChildPath 'AppData' `n" .
    "        try {`n" .
    "            Remove-Item -Path $_.FullName -Recurse -Force`n" .
    "        } catch {`n" .
    "            Write-Host 'Não foi possível remover: ' + $_.FullName + ' - ' + $_.Exception.Message`n" .
    "        }`n" .
    "    }`n" .
    "} `n" .
    "$users = Get-LocalUser | Where-Object { $_.Name -notin @('Administrador', 'Convidado', 'DefaultAccount', 'gaia', 'suport', 'WDAGUtilityAccount') }`n" . 
    "foreach ($user in $users) {`n" .
    "    Remove-LocalUser -Name $user.Name`n" .
    "} `n"
    
}  else {
    MsgBox("Operação Cancelada.")
    ExitApp()
}

RunAsAdmin(command)
ExitApp()