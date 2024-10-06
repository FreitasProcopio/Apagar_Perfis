Persistent
#Requires Autohotkey v2.0
#SingleInstance Force

; Define o caminho do PowerShell
psScript := """
(
    param (
        [String]$rootPath
    )
    
    # Verifica se o caminho raíz é um diretório
    if (-Not (Test-Path -Path $rootPath -PathType Container)) {
        Write-Host 'O caminho especificado não é um diretório válido.'
        exit
    }

    # Remove a pasta AppData dentro de cada diretório do caminho raíz
    $dirs = Get-ChildItem -Path $rootPath -Directory
    foreach ($dir in $dirs) {
        $appDataPath = Join-Path -Path $dir.FullName -ChildPath 'AppData'
        if (Test-Path -Path $appDataPath -PathType Container) {
            try {
                Remove-Item -Path $appDataPath -Recurse -Force
                Write-Host 'Removido: ' + $appDataPath
            } catch {
                Write-Host 'Não foi possível remover: ' + $appDataPath + ' - ' + $_.Exception.Message
            }
        }
    }
)"""

; Define o caminho raiz onde procurar as pastas
rootPath := "C:\Users\leda.pereira_escolap"

; Executa o script PowerShell passando o caminho raíz
RunWait % "powershell -NoProfile -ExecutionPolicy Bypass -Command `"& { " psScript -rootPath '" rootPath "' }`""
