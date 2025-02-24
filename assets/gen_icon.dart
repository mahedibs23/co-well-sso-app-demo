import 'dart:developer';
import 'dart:io';

void main() {
  const pngDir = 'assets/images/png';
  const svgDir = 'assets/images/svg';
  const outputFile = 'lib/presentation/values/app_assets.dart';

  final output = StringBuffer();
  output.writeln('// Run `dart gen_icon.dart` to generate this file.');
  output.writeln(
    '// Additionally you can use Android Studio run config or VSCode launch config.',
  );
  output.writeln('abstract final class AppAssets {');
  output.writeln('  static const String dir = "assets/images";');
  output.writeln('  static const String dirPng = "\$dir/png";');
  output.writeln('  static const String dirSvg = "\$dir/svg";');

  final pngFiles = getFilesSorted(pngDir);
  final svgFiles = getFilesSorted(svgDir);
  output.writeln();
  output.writeln('  // List of all .png in alphabetical order');

  for (final file in pngFiles) {
    final fileName = file.uri.pathSegments.last;
    final varName = convertToVarName(fileName);
    output.writeln('  static const String $varName = "\$dirPng/$fileName";');
  }
  output.writeln();
  output.writeln('  // List of all .svg in alphabetical order');

  for (final file in svgFiles) {
    final fileName = file.uri.pathSegments.last;
    final varName = convertToVarName(fileName);
    output.writeln('  static const String $varName = "\$dirSvg/$fileName";');
  }

  output.writeln('}');

  final outputFilePath = File(outputFile);
  outputFilePath.createSync(recursive: true);
  outputFilePath.writeAsStringSync(output.toString());

  log('$outputFile generated successfully!');
}

List<File> getFilesSorted(String directory) {
  final dir = Directory(directory);
  if (!dir.existsSync()) return [];
  return dir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.png') || file.path.endsWith('.svg'))
      .toList()
    ..sort(
        (a, b) => a.uri.pathSegments.last.compareTo(b.uri.pathSegments.last));
}

String convertToVarName(String fileName) {
  final nameWithoutExtension = fileName.split('.').first;
  return nameWithoutExtension
      .replaceAllMapped(
          RegExp(r'[_-]+(.)'), (match) => match.group(1)!.toUpperCase())
      .replaceFirstMapped(
          RegExp(r'^[A-Z]'), (match) => match.group(0)!.toLowerCase());
}
