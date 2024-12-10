Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Functie om toetsenbordindeling te resetten naar Verenigde Staten (Internationaal)
function Reset-KeyboardLayout {
    Write-Host "Resetten van toetsenbordinstellingen naar Verenigde Staten (Internationaal)..." -ForegroundColor Cyan
    try {
        $langList = Get-WinUserLanguageList
        $langList[0].InputMethodTips.Add("0409:00020409") # Verenigde Staten (Internationaal) code
        Set-WinUserLanguageList $langList -Force
        [System.Windows.Forms.MessageBox]::Show("De toetsenbordinstelling is gewijzigd naar Verenigde Staten (Internationaal).", "Succes")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Er is een fout opgetreden bij het wijzigen van de toetsenbordinstelling.", "Fout")
    }
}

# Functie om de cache van Google Chrome te wissen
function Clear-ChromeCache {
    Write-Host "Google Chrome cache wordt gewist..." -ForegroundColor Cyan
    try {
        $chromeCachePath = "$env:LocalAppData\Google\Chrome\User Data\Default\Cache"
        if (Test-Path $chromeCachePath) {
            Remove-Item -Path $chromeCachePath\* -Recurse -Force
            [System.Windows.Forms.MessageBox]::Show("De Google Chrome-cache is succesvol gewist.", "Succes")
        } else {
            [System.Windows.Forms.MessageBox]::Show("Google Chrome-cachemap niet gevonden. Chrome is mogelijk niet geïnstalleerd.", "Fout")
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Er is een fout opgetreden bij het wissen van de Google Chrome-cache.", "Fout")
    }
}

# Functie om Wi-Fi-resetscript aan te roepen
function Reset-WiFi {
    $wifiScriptPath = "C:\tmp\ResetWiFi.ps1"
    if (Test-Path $wifiScriptPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $wifiScriptPath" -Verb RunAs
    } else {
        [System.Windows.Forms.MessageBox]::Show("Het Wi-Fi-resetscript is niet gevonden!", "Fout")
    }
}

# Functie om Windows Updates uit te voeren
function Invoke-WindowsUpdate {
    try {
        # Meld aan de gebruiker dat updates worden gestart
        [System.Windows.Forms.MessageBox]::Show("Windows Updates worden uitgevoerd. Dit kan enige tijd duren...", "Windows Updates")
        
        # Start het Windows Update proces
        Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", "UsoClient StartInstall" -Verb RunAs
        
        # Laat de gebruiker weten dat de updates zijn gestart
        [System.Windows.Forms.MessageBox]::Show("Windows Updates zijn gestart. Controleer later of herstarten nodig is.", "Succes")
    } catch {
        # Meld eventuele fouten
        [System.Windows.Forms.MessageBox]::Show("Er is een fout opgetreden bij het starten van Windows Updates.", "Fout")
    }
}


# Functie om Dell Command Update uit te voeren
function Invoke-DellCommandUpdate {
    $dcuScriptPath = "C:\tmp\RunDellCommandUpdate.ps1"
    if (Test-Path $dcuScriptPath) {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File $dcuScriptPath" -Verb RunAs
    } else {
        [System.Windows.Forms.MessageBox]::Show("Het Dell Command Update script is niet gevonden!", "Fout")
    }
}

# Submenu: Update Menu
function Show-UpdateMenu {
    $updateForm = New-Object System.Windows.Forms.Form
    $updateForm.Text = "Update Opties"
    $updateForm.Size = New-Object System.Drawing.Size(400, 300)
    $updateForm.StartPosition = "CenterScreen"

    # Titel label
    $updateTitle = New-Object System.Windows.Forms.Label
    $updateTitle.Text = "Kies een update optie:"
    $updateTitle.Size = New-Object System.Drawing.Size(300, 30)
    $updateTitle.Location = New-Object System.Drawing.Point(50, 20)
    $updateTitle.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
    $updateForm.Controls.Add($updateTitle)

    # Knop: Windows Updates
    $windowsUpdateButton = New-Object System.Windows.Forms.Button
    $windowsUpdateButton.Text = "Windows Updates"
    $windowsUpdateButton.Size = New-Object System.Drawing.Size(200, 40)
    $windowsUpdateButton.Location = New-Object System.Drawing.Point(100, 70)
    $windowsUpdateButton.Add_Click({
        Invoke-WindowsUpdate
    })
    $updateForm.Controls.Add($windowsUpdateButton)

    # Knop: Dell Command Updates
    $dellUpdateButton = New-Object System.Windows.Forms.Button
    $dellUpdateButton.Text = "Dell Updates"
    $dellUpdateButton.Size = New-Object System.Drawing.Size(200, 40)
    $dellUpdateButton.Location = New-Object System.Drawing.Point(100, 130)
    $dellUpdateButton.Add_Click({
        Invoke-DellCommandUpdate
    })
    $updateForm.Controls.Add($dellUpdateButton)

    # Knop: Terug
    $backButton = New-Object System.Windows.Forms.Button
    $backButton.Text = "Terug"
    $backButton.Size = New-Object System.Drawing.Size(200, 40)
    $backButton.Location = New-Object System.Drawing.Point(100, 190)
    $backButton.Add_Click({
        $updateForm.Close()
    })
    $updateForm.Controls.Add($backButton)

    [void]$updateForm.ShowDialog()
}

# Hoofdmenu
$form = New-Object System.Windows.Forms.Form
$form.Text = "Zelfservice Menu"
$form.Size = New-Object System.Drawing.Size(400, 400)
$form.StartPosition = "CenterScreen"

# Titel label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "Kies een optie:"
$titleLabel.Size = New-Object System.Drawing.Size(300, 30)
$titleLabel.Location = New-Object System.Drawing.Point(50, 20)
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($titleLabel)

# Knop: Reset Wi-Fi Adapter
$wifiButton = New-Object System.Windows.Forms.Button
$wifiButton.Text = "Reset Wi-Fi Adapter"
$wifiButton.Size = New-Object System.Drawing.Size(200, 40)
$wifiButton.Location = New-Object System.Drawing.Point(100, 70)
$wifiButton.Add_Click({
    Reset-WiFi
})
$form.Controls.Add($wifiButton)

# Knop: Reset Toetsenbordindeling
$keyboardButton = New-Object System.Windows.Forms.Button
$keyboardButton.Text = "Reset Toetsenbord (VS Internationaal)"
$keyboardButton.Size = New-Object System.Drawing.Size(200, 40)
$keyboardButton.Location = New-Object System.Drawing.Point(100, 130)
$keyboardButton.Add_Click({
    Reset-KeyboardLayout
})
$form.Controls.Add($keyboardButton)

# Knop: Google Chrome Problemen (Cache wissen)
$chromeButton = New-Object System.Windows.Forms.Button
$chromeButton.Text = "Google Chrome Problemen"
$chromeButton.Size = New-Object System.Drawing.Size(200, 40)
$chromeButton.Location = New-Object System.Drawing.Point(100, 190)
$chromeButton.Add_Click({
    Clear-ChromeCache
})
$form.Controls.Add($chromeButton)

# Knop: Update Menu
$updateMenuButton = New-Object System.Windows.Forms.Button
$updateMenuButton.Text = "Update Opties"
$updateMenuButton.Size = New-Object System.Drawing.Size(200, 40)
$updateMenuButton.Location = New-Object System.Drawing.Point(100, 250)
$updateMenuButton.Add_Click({
    Show-UpdateMenu
})
$form.Controls.Add($updateMenuButton)

# Knop: Sluiten
$exitButton = New-Object System.Windows.Forms.Button
$exitButton.Text = "Sluiten"
$exitButton.Size = New-Object System.Drawing.Size(200, 40)
$exitButton.Location = New-Object System.Drawing.Point(100, 310)
$exitButton.Add_Click({
    $form.Close()
})
$form.Controls.Add($exitButton)

[void]$form.ShowDialog()