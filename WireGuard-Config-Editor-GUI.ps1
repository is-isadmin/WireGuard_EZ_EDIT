Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object Windows.Forms.Form
$form.Text = "WireGuard Config Modifier"
$form.Size = New-Object Drawing.Size(500, 300)
$form.StartPosition = "CenterScreen"

# Folder label and textbox
$folderLabel = New-Object Windows.Forms.Label
$folderLabel.Text = "Source Folder:"
$folderLabel.Location = New-Object Drawing.Point(10, 20)
$folderLabel.Size = New-Object Drawing.Size(100, 20)
$form.Controls.Add($folderLabel)

$folderBox = New-Object Windows.Forms.TextBox
$folderBox.Location = New-Object Drawing.Point(120, 20)
$folderBox.Size = New-Object Drawing.Size(250, 20)
$form.Controls.Add($folderBox)

$browseButton = New-Object Windows.Forms.Button
$browseButton.Text = "Browse"
$browseButton.Location = New-Object Drawing.Point(380, 18)
$browseButton.Size = New-Object Drawing.Size(75, 25)
$form.Controls.Add($browseButton)

# DNS input
$dnsLabel = New-Object Windows.Forms.Label
$dnsLabel.Text = "DNS:"
$dnsLabel.Location = New-Object Drawing.Point(10, 60)
$dnsLabel.Size = New-Object Drawing.Size(100, 20)
$form.Controls.Add($dnsLabel)

$dnsBox = New-Object Windows.Forms.TextBox
$dnsBox.Location = New-Object Drawing.Point(120, 60)
$dnsBox.Size = New-Object Drawing.Size(250, 20)
$form.Controls.Add($dnsBox)

# AllowedIPs input
$allowedLabel = New-Object Windows.Forms.Label
$allowedLabel.Text = "AllowedIPs:"
$allowedLabel.Location = New-Object Drawing.Point(10, 100)
$allowedLabel.Size = New-Object Drawing.Size(100, 20)
$form.Controls.Add($allowedLabel)

$allowedBox = New-Object Windows.Forms.TextBox
$allowedBox.Location = New-Object Drawing.Point(120, 100)
$allowedBox.Size = New-Object Drawing.Size(250, 20)
$form.Controls.Add($allowedBox)

# Status label
$statusLabel = New-Object Windows.Forms.Label
$statusLabel.Text = ""
$statusLabel.Location = New-Object Drawing.Point(10, 180)
$statusLabel.Size = New-Object Drawing.Size(460, 40)
$form.Controls.Add($statusLabel)

# Process button
$processButton = New-Object Windows.Forms.Button
$processButton.Text = "Process Files"
$processButton.Location = New-Object Drawing.Point(180, 140)
$processButton.Size = New-Object Drawing.Size(120, 30)
$form.Controls.Add($processButton)

# Browse button click
$browseButton.Add_Click({
    $dialog = New-Object Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select the folder containing WireGuard .conf files"
    if ($dialog.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        $folderBox.Text = $dialog.SelectedPath
    }
})

# Process button click
$processButton.Add_Click({
    $sourceFolder = $folderBox.Text
    $dns = $dnsBox.Text
    $allowedIPs = $allowedBox.Text

    if (-not (Test-Path $sourceFolder)) {
        $statusLabel.Text = "? Invalid folder path."
        return
    }

    $processedFolder = "$sourceFolder\processed"
    $backupFolder = "$sourceFolder\backup"

    foreach ($folder in @($processedFolder, $backupFolder)) {
        if (-not (Test-Path $folder)) {
            New-Item -ItemType Directory -Path $folder | Out-Null
        }
    }

    $files = Get-ChildItem -Path $sourceFolder -Filter *.conf
    if ($files.Count -eq 0) {
        $statusLabel.Text = "?? No .conf files found in selected folder."
        return
    }

    $counter = 0
    $total = $files.Count

    foreach ($file in $files) {
        $originalContent = Get-Content $file.FullName
        Copy-Item $file.FullName -Destination "$backupFolder\$($file.Name)"

        $modifiedContent = $originalContent | ForEach-Object {
            if ($_ -match '^DNS\s*=') {
                "DNS = $dns"
            } elseif ($_ -match '^AllowedIPs\s*=') {
                "AllowedIPs = $allowedIPs"
            } else {
                $_
            }
        }

        $modifiedContent | Set-Content "$processedFolder\$($file.Name)"

        $counter++
        $statusLabel.Text = "Processing file $counter of $total..."
        $statusLabel.Refresh()
    }

    $statusLabel.Text = "$counter files processed. Modified files in 'processed', originals in 'backup'."
})

# Run the form
[Windows.Forms.Application]::EnableVisualStyles()
[Windows.Forms.Application]::Run($form)