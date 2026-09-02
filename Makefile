.PHONY: gen clean-gen run analyze format version bump-build bump-patch bump-minor bump-major set-version build-apk build-aab build-ipa fastlane-android-internal fastlane-android-alpha fastlane-android-beta fastlane-android-production fastlane-android-promote fastlane-ios-beta fastlane-ios-release deploy-android-internal deploy-android-beta deploy-android-production deploy-ios-beta deploy-ios-release deploy-beta deploy-release _version_check

# =============================================================================
# Code Generation & Development
# =============================================================================

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
	dart format lib/ test/ scripts/

# =============================================================================
# Version & Build Number Management (pubspec.yaml)
# =============================================================================

# Display current version and build number from pubspec.yaml
version:
	@dart run scripts/bump_version.dart get

# Increment build number only (e.g. 1.0.0+1 -> 1.0.0+2)
bump-build:
	@dart run scripts/bump_version.dart build

# Increment patch version and build number (e.g. 1.0.0+1 -> 1.0.1+2)
bump-patch:
	@dart run scripts/bump_version.dart patch

# Increment minor version, reset patch, and bump build number (e.g. 1.0.0+1 -> 1.1.0+2)
bump-minor:
	@dart run scripts/bump_version.dart minor

# Increment major version, reset minor/patch, and bump build number (e.g. 1.0.0+1 -> 2.0.0+2)
bump-major:
	@dart run scripts/bump_version.dart major

# Set an explicit version (Usage: make set-version v=1.2.0+15)
set-version:
	@dart run scripts/bump_version.dart set $(v)

# Internal: reads version from pubspec.yaml and prints a reminder
_version_check:
	@dart run scripts/bump_version.dart get

# =============================================================================
# Local Builds (Flutter CLI)
# =============================================================================

# Build release APK (clean -> pub get -> codegen -> build)
build-apk: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build apk --release

# Build release Android App Bundle - use this for Play Store uploads
build-aab: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build appbundle --release

# Build release IPA - SPM only, no pod install needed
build-ipa: _version_check
	flutter clean && flutter pub get && $(MAKE) clean-gen && flutter build ipa --release

# =============================================================================
# Fastlane Deployments (Android)
# =============================================================================

# Fastlane: Upload to Google Play Internal Testing track
fastlane-android-internal:
	cd android && bundle exec fastlane internal || fastlane internal

# Fastlane: Upload to Google Play Closed Testing (Alpha)
fastlane-android-alpha:
	cd android && bundle exec fastlane alpha || fastlane alpha

# Fastlane: Upload to Google Play Open Testing (Beta)
fastlane-android-beta:
	cd android && bundle exec fastlane beta || fastlane beta

# Fastlane: Upload to Google Play Production track
fastlane-android-production:
	cd android && bundle exec fastlane production || fastlane production

# Fastlane: Promote Internal release to Production track
fastlane-android-promote:
	cd android && bundle exec fastlane promote_internal_to_production || fastlane promote_internal_to_production

# =============================================================================
# Fastlane Deployments (iOS)
# =============================================================================

# Fastlane: Upload to TestFlight (Beta Testing) via ASC API Key (.p8)
fastlane-ios-beta:
	cd ios && bundle exec fastlane beta || fastlane beta

# Fastlane: Upload to App Store (Production) via ASC API Key (.p8)
fastlane-ios-release:
	cd ios && bundle exec fastlane release || fastlane release

# =============================================================================
# Automated Workflows (Auto-Increment + Fastlane Deploy)
# =============================================================================

# Bump build code and deploy to Google Play Internal track
deploy-android-internal: bump-build fastlane-android-internal

# Bump build code and deploy to Google Play Beta track
deploy-android-beta: bump-build fastlane-android-beta

# Bump patch version + build code and deploy to Google Play Production
deploy-android-production: bump-patch fastlane-android-production

# Bump build code and deploy to Apple TestFlight
deploy-ios-beta: bump-build fastlane-ios-beta

# Bump patch version + build code and deploy to Apple App Store
deploy-ios-release: bump-patch fastlane-ios-release

# Bump build code and deploy both Android Internal and iOS TestFlight
deploy-beta: bump-build
	$(MAKE) fastlane-android-internal
	$(MAKE) fastlane-ios-beta

# Bump patch version + build code and deploy both Android & iOS Production
deploy-release: bump-patch
	$(MAKE) fastlane-android-production
	$(MAKE) fastlane-ios-release
