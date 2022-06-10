@echo off

set version=%1

cmd /c flutter clean
cmd /c flutter pub get
cmd /c flutter pub run build_runner build --delete-conflicting-outputs
cmd /c flutter build apk --release --build-name=%version%


for /f "delims=" %%a in ('wmic OS Get localdatetime  ^| find "."') do set dt=%%a
set YYYY=%dt:~0,4%
set MM=%dt:~4,2%
set DD=%dt:~6,2%
set HH=%dt:~8,2%
set Min=%dt:~10,2%
set Sec=%dt:~12,2%

set stamp=%YYYY%-%MM%-%DD%@%HH%-%Min%
rem you could for example want to create a folder in Gdrive and save backup there %stamp%

copy build\app\outputs\flutter-apk\app-release.apk ".\app-release-v%version%-%stamp%.apk"