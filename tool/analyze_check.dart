import 'dart:io';

void main() async {
  final process = await Process.start('dart', ['analyze', 'lib']);
  final output = await process.stdout.transform(SystemEncoding().decoder).join();
  final errorOutput = await process.stderr.transform(SystemEncoding().decoder).join();
  final _ = await process.exitCode; // ignore unused variable warning

  print(output);
  if (errorOutput.isNotEmpty) {
    print('Analyzer stderr:\n$errorOutput');
  }

  final errorLines = output.split('\n').where((line) => line.contains('error •')).toList();

  if (errorLines.isNotEmpty) {
    print('❌ Found ${errorLines.length} analyzer error(s):');
    for (var line in errorLines) {
      print(line);
    }
    exit(1);
  } else {
    print('✅ No analyzer errors found');
    exit(0);
  }
}
