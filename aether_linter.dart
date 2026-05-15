// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('===================================================');
  print('🛡️  Aether Architecture Linter (Diagnostic Mode) 🛡️');
  print('===================================================');

  // Validate project root
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) {
    print('❌ ERROR: Not in a Flutter project root.');
    return;
  }

  final reportFile = File('ARCHITECTURE_REPORT.md');
  final out = StringBuffer();
  out.writeln('# Aether Diagnostic Report\n');

  final isWindows = Platform.isWindows;
  final flutterCmd = isWindows ? 'flutter.bat' : 'flutter';

  // Static Analysis Check
  print('⏳ Running Diagnostic: Code Quality...');
  try {
    final analyze = await Process.run(flutterCmd, ['analyze']);
    out.writeln('### 1. Code Quality');
    if (analyze.exitCode == 0) {
      print('✅ Code Quality: PASS');
      out.writeln('✅ **PASS:** Zero static analysis warnings.');
    } else {
      print('❌ Code Quality: FAIL');
      out.writeln('❌ **FAIL:** Static analysis found issues.');
      out.writeln('\n💡 **RESOLUTION:** Run `flutter analyze` and resolve all warnings.');
    }
  } catch (e) {
    print('❌ ERROR: Could not run static analysis.');
    return;
  }

  // Concurrency Stress Test
  print('⏳ Running Diagnostic: Concurrency Verification...');
  final testFile = File('test/raid_concurrency_test.dart');
  
  out.writeln('\n### 2. Concurrency Outcome');
  if (!testFile.existsSync()) {
    print('❌ Concurrency: FAIL (Missing test file)');
    out.writeln('❌ **FAIL:** Missing `test/raid_concurrency_test.dart`.');
  } else {
    try {
      final testResult = await Process.run(flutterCmd, ['test', 'test/raid_concurrency_test.dart']);
      if (testResult.exitCode == 0) {
        print('✅ Concurrency: PASS');
        out.writeln('✅ **PASS:** Architecture handled high-concurrency race conditions.');
      } else {
        print('❌ Concurrency: FAIL');
        out.writeln('❌ **FAIL:** The concurrency test failed to maintain data integrity.');
        out.writeln('\n💡 **RESOLUTION:** Ensure `joinRaid()` uses atomic transactions or locks.');
      }
    } catch (e) {
      print('❌ ERROR: Could not execute concurrency tests.');
    }
  }

  try {
    reportFile.writeAsStringSync(out.toString());
    print('\n===================================================');
    print('📄 Report saved to ARCHITECTURE_REPORT.md');
    print('===================================================');
  } catch (e) {
    print('❌ Could not write to report file.');
  }
}
