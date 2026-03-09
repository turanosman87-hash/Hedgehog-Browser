::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFA9BXgWMAE+1EbsQ5+n//NaPp0kaUeowf8HS2bvAKeMcig==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSzk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Hedgehog Browser v2.0 - Nihai Sistem Kilidi
setlocal enabledelayedexpansion

:: 1. YÖNETİCİ KONTROLÜ (ZORUNLU)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [!] LUTFEN SAG TIKLAYIP 'YONETICI OLARAK CALISTIR' DEYIN!
    pause
    exit /b
)

:: 2. DİZİN VE İKON HAZIRLIĞI
set "ffPath=C:\Program Files\Mozilla Firefox"
set "iconPath=C:\Hedgehog"
if not exist "%iconPath%" mkdir "%iconPath%"
if not exist "%ffPath%" (
    echo [!] Firefox bulunamadi. Lutfen Firefox'u kurun.
    pause
    exit /b
)

:: İkonları İndir (İnternet bağlantısı gerektirir)
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://img.icons8.com/color/48/hedgehog.ico', '%iconPath%\hedgehog.ico')"
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('https://cdn-icons-png.flaticon.com/512/2151/2151474.png', '%iconPath%\hedgehog.png')"

:: 3. FIREFOX POLİTİKALARINI SİSTEME "ÇİVİLE" (REGISTRY)
:: Bu kısım Firefox'un kalbine hükmeder.
set "regP=HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Mozilla\Firefox"

:: Önce eski politikaları temizle (Çakışma olmasın)
reg delete "%regP%" /f >nul 2>&1

:: Temel Kısıtlamalar
reg add "%regP%" /v "DisablePrivateBrowsing" /t REG_DWORD /d 1 /f
reg add "%regP%" /v "BlockAboutConfig" /t REG_DWORD /d 1 /f
reg add "%regP%" /v "DisableSafeMode" /t REG_DWORD /d 1 /f
reg add "%regP%" /v "InstallAddonsPermission" /t REG_SZ /d "{\"Default\":false}" /f

:: VPN VE TÜM UZANTILARI SİL / YASAKLA
reg add "%regP%\ExtensionSettings" /v "*" /t REG_SZ /d "{\"installation_mode\":\"blocked\"}" /f

:: DEV BLOK LİSTESİ (Tüm Sosyal Medya, Oyun, Bahis, Şiddet, Cinsellik, Ekşi, Reddit)
:: Tek satırda MULTI_SZ formatında ekleme
set "b=*.facebook.com\0*.instagram.com\0*.twitter.com\0*.x.com\0*.eksisozluk.com\0*.reddit.com\0*.4chan.org\0*.twitch.tv\0*.kick.com\0*.whatsapp.com\0*.telegram.org\0*.tinder.com\0*.badoo.com\0*.escort*.*\0*.p*rn*hub.com\0*.xvideos.com\0*.livegore.com\0*.bestgore.com\0*.bet*.com\0*.casino*.*"
reg add "%regP%\WebsiteFilter" /v "Block" /t REG_MULTI_SZ /d "%b%" /f

:: GÜVENLİ ARAMA (Google & YouTube)
reg add "%regP%" /v "ForceGoogleSafeSearch" /t REG_DWORD /d 1 /f
reg add "%regP%" /v "ForceYouTubeSafetyMode" /t REG_DWORD /d 1 /f

:: 4. ANA SAYFAYI HEDGEHOG YAP
echo ^<html^>^<body style='background:#121212;color:#ffcc00;text-align:center;font-family:sans-serif;padding-top:100px;'^>^<img src='file:///%iconPath:\=/%/hedgehog.png' width='150'^>^<h1^>HEDGEHOG BROWSER^</h1^>^<p style='color:white;'^>Odaklan. Bilgiye ulas. Dis dunyayi kapat.^</p^>^</body^>^</html^> > "%iconPath%\home.html"
reg add "%regP%\Homepage" /v "URL" /t REG_SZ /d "file:///%iconPath:\=/%/home.html" /f
reg add "%regP%\Homepage" /v "Locked" /t REG_DWORD /d 1 /f

:: 5. SİSTEM DNS KİLİDİ
netsh interface ip set dns name="Wi-Fi" static 185.228.168.168
netsh interface ip set dns name="Ethernet" static 185.228.168.168

:: 6. KISAYOLU SIFIRDAN OLUŞTUR
set "SPath=%userprofile%\Desktop\Hedgehog Browser.lnk"
if exist "%SPath%" del "%SPath%"
powershell -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%SPath%');$s.TargetPath='%ffPath%\firefox.exe';$s.IconLocation='%iconPath%\hedgehog.ico';$s.Save()"

echo --------------------------------------------------
echo [OK] HEDGEHOG KURULDU. LUTFEN BILGISAYARI YENIDEN BASLATIN!
echo --------------------------------------------------
pause