import 'dart:io';

/// CLI tool to increment or set the application version and build number in `pubspec.yaml`.
///
/// Usage:
///   dart run scripts/bump_version.dart [build|patch|minor|major|get|set <version>]
void main(List<String> args) {
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    stderr.writeln('Error: pubspec.yaml not found in current directory.');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  final versionRegex = RegExp(
    r'^version:\s*([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)',
    multiLine: true,
  );
  final match = versionRegex.firstMatch(content);

  if (match == null) {
    stderr.writeln(
      'Error: Could not find valid version line (format: x.y.z+n) in pubspec.yaml.',
    );
    exit(1);
  }

  int major = int.parse(match.group(1)!);
  int minor = int.parse(match.group(2)!);
  int patch = int.parse(match.group(3)!);
  int build = int.parse(match.group(4)!);

  final oldVersionString = '$major.$minor.$patch+$build';
  final command = args.isNotEmpty ? args.first.toLowerCase() : 'build';

  if (command == 'get' || command == 'current' || command == 'check') {
    stdout
      ..writeln('Current version: $major.$minor.$patch (build: $build)')
      ..writeln('Full version: $oldVersionString');
    return;
  }

  if (command == 'set') {
    if (args.length < 2) {
      stderr.writeln(
        'Error: Missing version argument for "set". Example: dart run scripts/bump_version.dart set 1.2.0+15',
      );
      exit(1);
    }
    final target = args[1].trim();
    final customRegex = RegExp(r'^([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)$');
    if (!customRegex.hasMatch(target)) {
      stderr.writeln(
        'Error: Invalid version format "$target". Must be "x.y.z+n" (e.g. 1.2.0+15).',
      );
      exit(1);
    }
    final newContent = content.replaceFirst(versionRegex, 'version: $target');
    pubspecFile.writeAsStringSync(newContent);
    stdout.writeln('✓ Version updated: $oldVersionString -> $target');
    return;
  }

  switch (command) {
    case 'build':
    case 'code':
      build += 1;
      break;
    case 'patch':
      patch += 1;
      build += 1;
      break;
    case 'minor':
      minor += 1;
      patch = 0;
      build += 1;
      break;
    case 'major':
      major += 1;
      minor = 0;
      patch = 0;
      build += 1;
      break;
    default:
      stderr
        ..writeln('Error: Unknown command "$command".')
        ..writeln(
          'Available options: build, patch, minor, major, get, set <x.y.z+n>',
        );
      exit(1);
  }

  final newVersionString = '$major.$minor.$patch+$build';
  final newContent = content.replaceFirst(
    versionRegex,
    'version: $newVersionString',
  );
  pubspecFile.writeAsStringSync(newContent);

  stdout
    ..writeln('---------------------------------------------------')
    ..writeln('  Previous : $oldVersionString')
    ..writeln(
      '  New      : $newVersionString (Version: $major.$minor.$patch, Build: $build)',
    )
    ..writeln('---------------------------------------------------');
}
