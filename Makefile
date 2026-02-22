run:
	flutter run --dart-define-from-file=.env

gen-code:
	dart run build_runner build --delete-conflicting-outputs

clean:
	flutter clean
	flutter pub get