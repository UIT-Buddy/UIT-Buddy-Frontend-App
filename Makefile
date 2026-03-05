help:
	@echo "Available commands:"
	@echo "  run       - Run the Flutter application with environment variables from .env file"
	@echo "  gen-code   - Generate code using build_runner"
	@echo "  format     - Format the Dart code, Remember to run this before committing, or you may receive fail CI checks"
	@echo "  clean      - Clean the Flutter project and get dependencies"

run:
	flutter run --dart-define-from-file=.env

gen-code:
	dart run build_runner build --delete-conflicting-outputs

format:
	dart format .

clean:
	flutter clean
	flutter pub get

.PHONY: help run gen-code format clean