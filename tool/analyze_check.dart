import 'dart:convert';
import 'dart:io';

void main() async {
  // Run `dart analyze` with JSON output on `lib`
  final process = await Process.start(
    'dart',
    ['analyze', 'lib', '--format', 'json'],
  );

  final output = await process.stdout.transform(utf8.decoder).join();
  final errorOutput = await process.stderr.transform(utf8.decoder).join();
  final exitCode = await process.exitCode;

  if (exitCode != 0 && errorOutput.isNotEmpty) {
    print('Analyzer error output:\n$errorOutput');
  }

  // Parse JSON output
  final decoded = jsonDecode(output) as Map<String, dynamic>;

  final diagnostics = decoded['diagnostics'] as List<dynamic>;

  // Filter errors only
  final errors = diagnostics.where((d) => d['severity'] == 'ERROR').toList();

  if (errors.isNotEmpty) {
    print('❌ Found ${errors.length} error(s):');
    for (var e in errors) {
      final loc = e['location'];
      final file = loc['file'];
      final line = loc['range']['start']['line'];
      final column = loc['range']['start']['column'];
      final message = e['problemMessage'];
      print('$file:$line:$column - $message');
    }
    exit(1); // Fail if errors found
  } else {
    print('✅ No analyzer errors found');
    exit(0);
  }
}

