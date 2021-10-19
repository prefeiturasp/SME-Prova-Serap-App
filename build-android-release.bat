@echo off

cmd /c flutter clean
cmd /c flutter pub get
cmd /c flutter pub run build_runner build --delete-conflicting-outputs
cmd /c flutter build apk --release