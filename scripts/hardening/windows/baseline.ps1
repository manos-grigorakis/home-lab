# Validates if the script is executed as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Run as Administrator!" -ForegroundColor Red
    exit
}

# Backup settings for rollback
Write-Host "Backup Settings for Rollback (C:\temp\before.cfg)" -ForegroundColor Green
if (!(Test-Path "C:\temp")) { New-Item -ItemType Directory -Path "C:\temp" | Out-Null }
secedit /export /cfg C:\temp\before.cfg

$KB = 1024
$SIZE_16MB = 16 * $KB
$SIZE_64MB = 64 * $KB
$SIZE_125MB = 125 * $KB
$SIZE_256MB = 256 * $KB
$SIZE_512MB = 512 * $KB

$FIREWALL_LOGFILEPATH = "%SystemRoot%\System32\logfiles\firewall\"
$PUBLIC_FIREWALL_LOGFILEPATH = "${FIREWALL_LOGFILEPATH}publicfw.log"
$DOMAIN_FIREWALL_LOGFILEPATH = "${FIREWALL_LOGFILEPATH}domainfw.log"
$PRIVATE_FIREWALL_LOGFILEPATH = "${FIREWALL_LOGFILEPATH}privatefw.log"

function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$Name,
        [string]$Type,
        [object]$Value
    )

    # Create key if it doesn't exist
    if (!(Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    # Set the value
    New-ItemProperty -Path $Path -Name $Name -PropertyType $Type -Value $Value -Force | Out-Null
}

# ========================
# Audit Policies
# ========================

Write-Host "=== Audit Policies ===" -ForegroundColor Cyan

# ID: 26139
Write-Host "[Audit] Credential Validation -> Success & Failure"
auditpol /set /subcategory:"Credential Validation" /success:enable /failure:enable

# ID: 26142
Write-Host "[Audit] User Account Management -> Success & Failure"
auditpol /set /subcategory:"User Account Management" /success:enable /failure:enable

# ID: 26144
Write-Host "[Audit] Process Creation -> Success"
auditpol /set /subcategory:"Process Creation" /success:enable /failure:disable

# ID: 26145
Write-Host "[Audit] Account Lockout -> Failure"
auditpol /set /subcategory:"Account Lockout" /success:disable /failure:enable

# ID: 26148
Write-Host "[Audit] Logon -> Success & Failure"
auditpol /set /subcategory:"Logon" /success:enable /failure:enable

# ========================
#  Account Policies
# ========================

Write-Host "=== Account Policies ===" -ForegroundColor Cyan

# ID: 26005
Write-Host "[Account] LockoutDuration -> 15"
net accounts /lockoutduration:15

# ID: 26006
Write-Host "[Account] LockoutThreshold -> 5"
net accounts /lockoutthreshold:5

# ID: 26007
Write-Host "[Account] LockoutWindow -> 15"
net accounts /lockoutwindow:15

# ID: 26003
Write-Host "[Account] MinimumPasswordLength -> 14"
net accounts /minpwlen:14

# ID: 26004
Write-Host "[Account(Registry)] RelaxMinimumPasswordLengthLimits -> 1"
Set-RegistryValue `
    -Path "HKLM:\System\CurrentControlSet\Control\SAM" `
    -Name "RelaxMinimumPasswordLengthLimits" `
    -Type "DWord" `
    -Value 1

# ========================
# Registry Settings
# ========================

Write-Host "=== Registry Settings ===" -ForegroundColor Cyan

# === Kerberos ===

# ID: 26053
Write-Host "[Registry] SupportedEncryptionTypes -> 2147483644"
Set-RegistryValue `
    -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" `
    -Name "SupportedEncryptionTypes" `
    -Type "DWord" `
    -Value 2147483644

# === NTLM ===

# ID: 26058
Write-Host "[Registry] NTLMMinClientSec -> 537395200"
Set-RegistryValue `
    -Path "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0" `
    -Name "NTLMMinClientSec" `
    -Type "DWord" `
    -Value 537395200

# ID: 26059
Write-Host "[Registry] NTLMMinServerSec -> 537395200"
Set-RegistryValue `
    -Path "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0" `
    -Name "NTLMMinServerSec" `
    -Type "DWord" `
    -Value 537395200

# ID: 26060
Write-Host "[Registry] AuditReceivingNTLMTraffic -> 2 (Audit / Restrict)"
Set-RegistryValue `
    -Path "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0" `
    -Name "AuditReceivingNTLMTraffic" `
    -Type "DWord" `
    -Value 2

# ID: 26061
Write-Host "[Registry] RestrictSendingNTLMTraffic -> 2 (Audit / Restrict)"
Set-RegistryValue `
    -Path "HKLM:\System\CurrentControlSet\Control\Lsa\MSV1_0" `
    -Name "RestrictSendingNTLMTraffic" `
    -Type "DWord" `
    -Value 2

# === Printers ===

# ID: 26015
Write-Host "[Registry] AddPrinterDrivers -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers" `
    -Name "AddPrinterDrivers" `
    -Type "DWord" `
    -Value 1

# ID: 26219
Write-Host "[Registry] UpdatePromptSettings -> 0 (No Prompt)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" `
    -Name "UpdatePromptSettings" `
    -Type "DWord" `
    -Value 0

# ID: 26246
Write-Host "[Registry] DisableWebPnPDownload -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers" `
    -Name "DisableWebPnPDownload" `
    -Type "DWord" `
    -Value 1

# ID: 26251
Write-Host "[Registry] DisableHTTPPrinting -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers" `
    -Name "DisableHTTPPrinting" `
    -Type "DWord" `
    -Value 1

# === WinRM ===

# ID: 26110
Write-Host "[Registry] WinRM Start -> 4 (Disabled)"
Set-RegistryValue `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WinRM" `
    -Name "Start" `
    -Type "DWord" `
    -Value 4

# === Windows Firewall ===

# === Public ===

# ID: 26135
Write-Host "[Registry] PublicFirewall LogFilePath -> $PUBLIC_FIREWALL_LOGFILEPATH"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" `
    -Name "LogFilePath" `
    -Type "String" `
    -Value $PUBLIC_FIREWALL_LOGFILEPATH

# ID: 26136
Write-Host "[Registry] PublicFirewall LogFileSize -> $($SIZE_16MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" `
    -Name "LogFileSize" `
    -Type "DWord" `
    -Value $SIZE_16MB

# ID: 26137
Write-Host "[Registry] PublicFirewall LogDroppedPackets -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" `
    -Name "LogDroppedPackets" `
    -Type "DWord" `
    -Value 1

# ID: 26138
Write-Host "[Registry] PublicFirewall LogSuccessfulConnections -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PublicProfile\Logging" `
    -Name "LogSuccessfulConnections" `
    -Type "DWord" `
    -Value 1

# === Domain ===

# ID: 26119
Write-Host "[Registry] DomainFirewall LogFilePath -> $DOMAIN_FIREWALL_LOGFILEPATH"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" `
    -Name "LogFilePath" `
    -Type "String" `
    -Value $DOMAIN_FIREWALL_LOGFILEPATH

# ID: 26120
Write-Host "[Registry] DomainFirewall LogFileSize -> $($SIZE_16MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" `
    -Name "LogFileSize" `
    -Type "DWord" `
    -Value $SIZE_16MB

# ID: 26121
Write-Host "[Registry] DomainFirewall LogDroppedPackets -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" `
    -Name "LogDroppedPackets" `
    -Type "DWord" `
    -Value 1

# ID: 26122
Write-Host "[Registry] DomainFirewall LogSuccessfulConnections -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\DomainProfile\Logging" `
    -Name "LogSuccessfulConnections" `
    -Type "DWord" `
    -Value 1

# === Private ===

# ID: 26126
Write-Host "[Registry] PrivateFirewall LogFilePath -> $PRIVATE_FIREWALL_LOGFILEPATH"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" `
    -Name "LogFilePath" `
    -Type "String" `
    -Value $PRIVATE_FIREWALL_LOGFILEPATH

# ID: 26127
Write-Host "[Registry] PrivateFirewall LogFileSize -> $($SIZE_16MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" `
    -Name "LogFileSize" `
    -Type "DWord" `
    -Value $SIZE_16MB

# ID: 26128
Write-Host "[Registry] PrivateFirewall LogDroppedPackets -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" `
    -Name "LogDroppedPackets" `
    -Type "DWord" `
    -Value 1

# ID: 26129
Write-Host "[Registry] PrivateFirewall LogSuccessfulConnections -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging" `
    -Name "LogSuccessfulConnections" `
    -Type "DWord" `
    -Value 1

# === Autoplay ===

# ID: 26301
Write-Host "[Registry] NoAutoplayfornonVolume -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" `
    -Name "NoAutoplayfornonVolume" `
    -Type "DWord" `
    -Value 1

# ID: 26302
Write-Host "[Registry] NoAutorun -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -Name "NoAutorun" `
    -Type "DWord" `
    -Value 1

# ID: 26303
Write-Host "[Registry] NoDriveTypeAutoRun -> 255"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
    -Name "NoDriveTypeAutoRun" `
    -Type "DWord" `
    -Value 255

# === Logging ===

# ID: 26374
Write-Host "[Registry] EventLog Application MaxSize -> $($SIZE_125MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" `
    -Name "MaxSize" `
    -Type "DWord" `
    -Value $SIZE_125MB

# ID: 26376
Write-Host "[Registry] EventLog Security MaxSize -> $($SIZE_512MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security" `
    -Name "MaxSize" `
    -Type "DWord" `
    -Value $SIZE_512MB

# ID: 26378
Write-Host "[Registry] EventLog Setup MaxSize -> $($SIZE_64MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Setup" `
    -Name "MaxSize" `
    -Type "DWord" `
    -Value $SIZE_64MB

# ID: 26380
Write-Host "[Registry] EventLog System MaxSize -> $($SIZE_256MB / 1024) MB"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System" `
    -Name "MaxSize" `
    -Type "DWord" `
    -Value $SIZE_256MB

# === Command Line & PowerShell ===
# ID: 26222
Write-Host "[Registry] ProcessCreationIncludeCmdLine_Enabled -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" `
    -Name "ProcessCreationIncludeCmdLine_Enabled" `
    -Type "DWord" `
    -Value 1

# ID: 26461
Write-Host "[Registry] EnableTranscripting -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription" `
    -Name "EnableTranscripting" `
    -Type "DWord" `
    -Value 1

# === Geolocation Service ===

# ID: 26076
Write-Host "[Registry] lfsvc Start -> 4 (Disabled)"
Set-RegistryValue `
    -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc" `
    -Name "Start" `
    -Type "DWord" `
    -Value 4

# === Other ===

# ID: 26273
Write-Host "[Registry] DontDisplayNetworkSelectionUI -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
    -Name "DontDisplayNetworkSelectionUI" `
    -Type "DWord" `
    -Value 1

# ID: 26276
Write-Host "[Registry] DisableLockScreenAppNotifications -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
    -Name "DisableLockScreenAppNotifications" `
    -Type "DWord" `
    -Value 1

# ID: 26277
Write-Host "[Registry] BlockDomainPicturePassword -> 1 (Enabled)"
Set-RegistryValue `
    -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" `
    -Name "BlockDomainPicturePassword" `
    -Type "DWord" `
    -Value 1