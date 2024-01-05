
# Leik Pa'O | Pa'O Library
You can download the pre-built version from the [release](https://github.com/KhunHtetzNaing/Leik-PaO/releases) page!

## Build for Web

To build for the web, use the following commands:

```bash
flutter build web --web-renderer canvaskit --release
# Copy to the release directory:
cp -r build/web release/web
```

## Build for Android
```bash
# Universal
flutter build apk --release
# Per ABI
flutter build apk --split-per-abi --release
# Copy all output APK files to the release directory:
cp build/app/outputs/flutter-apk/*.apk release
# Bundle for Play Store
flutter build appbundle --release
# Copy .aab to release directory:
copy build/app/outputs/bundle/release/app-release.aab release
```
## Build .ipa for iOS
```bash
# Gererate .app for iphone
flutter build ios --release
# Creating .app to .ipa
mkdir Payload
cp -r build/ios/Release-iphoneos/Runner.app Payload
zip -r leik_pao_ios.ipa Payload
rm -rf Payload
# Move .ipa to release directory
mv leik_pao_ios.ipa release/
```
You can install the generated .ipa file on your iPhone using any IPA installer, such as [SideLoadly](https://sideloadly.io/)!

## Build for macOS
```bash
# Gererate .app for mac
flutter build macos --release
# Move .app to release directory
mv build/macos/Build/Products/Release/*.app release/
```

## Build for Windows
```bash
# Clone this repo on Windows and run
git clone https://github.com/KhunHtetzNaing/Leik-PaO leik_pao
cd leik_pao
flutter build windows --release
```
Download [Inno Setup](https://www.jrsoftware.org/isdl.php#stable) and run `leik_pao.iss` for creating a standalone .exe.

## Todo
- [ ] ~~Splash Screen~~
- [x] Copy Text
- [ ] Search in PDF
- [x] Pa'O Zawgyi, ASCII, Unicode Converter
- [x] Share Downloaded PDF File
- [ ] Check Update
- [x] Add more categories
- [x] Change PDF reader layout

## Changelog

### Version 1.0.1

-   Copy text from PDF
-   Pa'O ASCII, Zawgyi, Unicode Converter
-   Change PDF Viewer Layout