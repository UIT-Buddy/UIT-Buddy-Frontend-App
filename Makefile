help:
	@echo "Available commands:"
	@echo "  run       - Run the Flutter application with environment variables from .env file"
	@echo "  gen-code   - Generate code using build_runner"
	@echo "  format     - Format the Dart code, Remember to run this before committing, or you may receive fail CI checks"
	@echo "  clean      - Clean the Flutter project and get dependencies"
	@echo "  unit-test  - Run unit tests"
	@echo "  test       - Try CI checks locally (format + analyze + unit tests)"
	@echo "  build-release - Build the apk release version of the app"
	@echo "  install-apk - Install APK to device (delete the old one if exists), grant full permissions, and launch app"

run:
	flutter run --dart-define-from-file=.env

gen-code:
	dart run build_runner build --delete-conflicting-outputs

format:
	dart format .

unit-test:
	flutter test test/ --no-pub

test:
	dart format --output=none --set-exit-if-changed .
	flutter analyze --fatal-infos --fatal-warnings
	flutter test test/ --no-pub

clean:
	flutter clean
	flutter pub get

build-release:
	@echo "Cleaning old APK files..."
	@rm -f build/app/outputs/apk/release/*.apk
	@echo "✓ Old APK files removed"
	@echo "\nBuilding release APK..."
	flutter build apk --release --dart-define-from-file=.env

install-apk: clean gen-code build-release
	@echo "Installing APK..."
	$(HOME)/Android/Sdk/platform-tools/adb install -r build/app/outputs/apk/release/app-release.apk
	@echo "\n✓ Installation successful!"
	@echo "\nAPK installed at:"
	@$(HOME)/Android/Sdk/platform-tools/adb shell pm path com.example.uit_buddy_mobile
	@echo "\nGranting permissions..."
	@$(HOME)/Android/Sdk/platform-tools/adb shell pm grant com.example.uit_buddy_mobile android.permission.ACCESS_FINE_LOCATION 2>/dev/null || true
	@$(HOME)/Android/Sdk/platform-tools/adb shell pm grant com.example.uit_buddy_mobile android.permission.ACCESS_COARSE_LOCATION 2>/dev/null || true
	@$(HOME)/Android/Sdk/platform-tools/adb shell pm grant com.example.uit_buddy_mobile android.permission.ACCESS_BACKGROUND_LOCATION 2>/dev/null || true
	@echo "✓ Permissions granted"
	@echo "\nLaunching app..."
	@$(HOME)/Android/Sdk/platform-tools/adb shell am start -n com.example.uit_buddy_mobile/.MainActivity
	@echo "✓ App launched successfully!"

.PHONY: help run gen-code format unit-test clean test build-release install-apk