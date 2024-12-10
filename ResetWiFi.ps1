Add-Type -AssemblyName System.Windows.Forms

# Functie om de Wi-Fi-adapter automatisch te detecteren
function Get-WiFiAdapter {
    $wifiAdapter = Get-NetAdapter | Where-Object { 
        $_.Name -like "*Wi-Fi*" -and $_.Status -ne "Disabled"
    }
    return $wifiAdapter
}

# Functie om de Wi-Fi-adapter te resetten en profielen te verwijderen
function Reset-WiFiAdapter {
    Write-Host "De Wi-Fi adapter wordt volledig gereset..." -ForegroundColor Cyan
    try {
        # Verwijder alle opgeslagen netwerken, inclusief Eduroam
        Write-Host "Verwijderen van alle opgeslagen Wi-Fi-profielen..." -ForegroundColor Yellow
        netsh wlan delete profile name=* | Out-Null
        Write-Host "Alle Wi-Fi-profielen zijn succesvol verwijderd." -ForegroundColor Green

        # Reset de adapter
        $wifiAdapter = Get-WiFiAdapter
        if ($wifiAdapter) {
            Disable-NetAdapter -Name $wifiAdapter.Name -Confirm:$false
            Start-Sleep -Seconds 2
            Enable-NetAdapter -Name $wifiAdapter.Name -Confirm:$false
            Start-Sleep -Seconds 5
            Write-Host "De Wi-Fi adapter is succesvol gereset." -ForegroundColor Green
        } else {
            Write-Host "Geen actieve Wi-Fi adapter gevonden." -ForegroundColor Red
        }
    } catch {
        Write-Host "Er is een fout opgetreden tijdens het resetten van de Wi-Fi adapter: $_" -ForegroundColor Red
    }
}

# Hoofdprogramma
Reset-WiFiAdapter

# Meld de gebruiker dat ze Eduroam opnieuw moeten verbinden
[System.Windows.Forms.MessageBox]::Show("De Wi-Fi adapter is gereset. Maak opnieuw verbinding met Eduroam. Gebruik je inlognaam in het formaat leerlingnummer@kempenhorst.nl of leerlingnummer@heerbeeck.nl en je wachtwoord.", "Informatie", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
