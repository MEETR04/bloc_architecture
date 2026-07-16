.PHONY: gen clean-gen run analyze format build-apk build-aab build-ipa _version_check

# Regenerate all build_runner outputs (models, routes, retrofit)
gen:
	dart run build_runner build

# Wipe all generated files and rebuild from scratch
clean-gen:
	dart run build_runner clean && dart run build_runner build

# Run the app in debug mode
run:
	flutter run

# Run static analysis
analyze:
	flutter analyze

# Format all Dart source files
format:
	dart format lib/ test/

# Internal: reads version from pubspec.yaml and prints a reminder
_version_check:
	$(eval VERSION := $(shell grep '^version:' pubspec.yaml | cut -d' ' -f2))
	$(eval APP_VERSION := $(shell echo "$(VERSION)" | cut -d'+' -f1))
	$(eval BUILD_NUMBER := $(shell echo "$(VERSION)" | cut -d'+' -f2))
	@echo "---------------------------------------------------"
	@echo "  Current version : $(APP_VERSION)"
	@echo "  Current build   : $(BUILD_NUMBER)"
	@echo "---------------------------------------------------"
	@echo "  ⚠️  Don't forget to increase build code and version!"
	@echo "---------------------------------------------------"

# Build release APK (clean → pub get → codegen → build)
build-apk: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build apk --release

# Build release Android App Bundle — use this for Play Store uploads
build-aab: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build appbundle --release

# Build release IPA — SPM only, no pod install needed
build-ipa: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build ipa --release
