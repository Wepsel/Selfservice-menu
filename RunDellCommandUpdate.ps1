# Laad de benodigde assemblies voor MessageBox
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Controleer of Dell Command Update geïnstalleerd is
$dcuPath = "C:\Program Files (x86)\Dell\CommandUpdate\dcu-cli.exe"
if (!(Test-Path $dcuPath)) {
    Write-Host "Dell Command Update is niet geïnstalleerd op dit systeem." -ForegroundColor Red
    exit
}

Write-Host "Dell Command Update zoekt naar updates..." -ForegroundColor Cyan
[System.Windows.Forms.MessageBox]::Show("Dell Command Update zoekt naar updates...", "Informatie", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)

# Fase 1: Zoeken naar updates
try {
    Start-Process -FilePath $dcuPath -ArgumentList "/scan" -Verb RunAs -Wait
    Write-Host "Zoeken naar updates voltooid. Updates worden nu geïnstalleerd..." -ForegroundColor Yellow

    # Fase 2: Updates toepassen
    $logFile = "C:\tmp\dcu-log.txt"
    Start-Process -FilePath $dcuPath -ArgumentList "/applyupdates /log $logFile" -Verb RunAs -Wait

    # Controleer logbestand voor fouten
    if (Test-Path $logFile) {
        Write-Host "Controleer het logbestand: $logFile" -ForegroundColor Cyan
    }

    # Succesmelding via pop-up
    [System.Windows.Forms.MessageBox]::Show("Dell Command Update heeft de updates succesvol geïnstalleerd.", "Succes", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
} catch {
    # Foutmelding via console en pop-up
    Write-Host "Er is een fout opgetreden tijdens het zoeken of installeren van updates: $_" -ForegroundColor Red
    [System.Windows.Forms.MessageBox]::Show("Er is een fout opgetreden tijdens het zoeken of installeren van updates.", "Fout", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}