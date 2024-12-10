# Functie om logberichten te schrijven
function Write-Log {
    param (
        [string]$message
    )
    $logFile = "C:\ProgramData\Snelkoppeling_log.txt"
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logMessage
}

# Ophalen van de huidige ingelogde gebruiker
Write-Log "Bezig met ophalen van de huidige gebruiker..."
$currentUser = (Get-WmiObject -Class Win32_ComputerSystem).UserName
if (-not $currentUser) {
    Write-Log "Fout: Kan de huidige gebruiker niet ophalen!"
    exit
}

# Bureaubladpad van de huidige gebruiker
$desktopPath = [System.IO.Path]::Combine("C:\Users", $currentUser.Split('\')[-1], "Desktop")
Write-Log "Bureaublad pad: $desktopPath"

# Map maken en bestanden verplaatsen
$targetDir = "C:\tmp"
Write-Log "Controleren of map $targetDir bestaat..."
if (!(Test-Path $targetDir)) {
    Write-Log "Map $targetDir bestaat niet. Creëer map."
    New-Item -ItemType Directory -Path $targetDir
} else {
    Write-Log "Map $targetDir bestaat al."
}

$sourceDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Log "Bestanden kopiëren van $sourceDir naar $targetDir..."

try {
    Copy-Item -Path "$sourceDir\ZelfserviceGUI.ps1" -Destination $targetDir -Force
    Write-Log "ZelfserviceGUI.ps1 gekopieerd naar $targetDir."

    Copy-Item -Path "$sourceDir\ResetWiFi.ps1" -Destination $targetDir -Force
    Write-Log "ResetWiFi.ps1 gekopieerd naar $targetDir."

    Copy-Item -Path "$sourceDir\ZelfserviceIcon.ico" -Destination $targetDir -Force
    Write-Log "ZelfserviceIcon.ico gekopieerd naar $targetDir."

    Copy-Item -Path "$sourceDir\RunDellCommandUpdate.ps1" -Destination $targetDir -Force
    Write-Log "RunDellCommandUpdate.ps1 gekopieerd naar $targetDir."
} catch {
    Write-Log "Fout bij het kopiëren van bestanden: $_"
}

# Controleren of de bureaubladmap bestaat
if (Test-Path -Path $desktopPath) {
    Write-Log "Bureaublad map gevonden: $desktopPath"
} else {
    Write-Log "Bureaublad map niet gevonden!"
    exit
}

# Snelkoppeling maken op bureaublad
$shell = New-Object -ComObject WScript.Shell
$shortcutPath = [System.IO.Path]::Combine($desktopPath, "Zelfservice.lnk")

Write-Log "Snelkoppeling maken op $shortcutPath..."

try {
    $shortcut = $shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -File C:\tmp\ZelfserviceGUI.ps1"
    $shortcut.IconLocation = "C:\tmp\ZelfserviceIcon.ico"
    $shortcut.Save()

    Write-Log "Snelkoppeling succesvol gemaakt op $shortcutPath."
} catch {
    Write-Log "Fout bij het maken van snelkoppeling: $_"
}

Write-Log "Script voltooid."