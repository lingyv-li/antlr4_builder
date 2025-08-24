import 'dart:io';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

const antlr4Version = '4.13.2';

void main() {
  group('AntlrBuilder Integration Test', () {
    late Directory tempDir;
    late String packagePath;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('antlr_builder_test_');
      packagePath = tempDir.path;

      // Print the working directory for debugging
      print('Temporary package path: $packagePath');

      // Create a dummy pubspec.yaml for the temporary package
      final pubspecContent = '''
name: test_package
environment:
  sdk: '>=3.0.0 <4.0.0'
dependencies:
  antlr4: ^$antlr4Version
dev_dependencies:
  antlr4_builder:
    path: ${p.current}
  build_runner: ^2.0.0
''';
      await File(p.join(packagePath, 'pubspec.yaml'))
          .writeAsString(pubspecContent);

      // Create a build.yaml for the temporary package
      final buildYamlContent = '''
targets:
  \$default:
    builders:
      antlr4_builder|antlrBuilder:
        enabled: true
        options:
          version: "$antlr4Version"
          generate_listener: true
          generate_visitor: true
          extra_args: ["-Werror"]
''';
      await File(p.join(packagePath, 'build.yaml'))
          .writeAsString(buildYamlContent);

      // Create a lib directory
      await Directory(p.join(packagePath, 'lib')).create();

      // Create a simple .g4 file
      final g4Lines = """
grammar Hello;
r : ID;
ID : [a-zA-Z]+;
""";
      await File(p.join(packagePath, 'lib', 'Hello.g4')).writeAsString(g4Lines);

      // Run dart pub get in the temporary package
      final pubGetResult = await Process.run(
        'dart',
        ['pub', 'get'],
        workingDirectory: packagePath,
      );
      if (pubGetResult.exitCode != 0) {
        fail('dart pub get failed: ${pubGetResult.stderr}');
      }
    });

    tearDown(() async {
      print('Contents of temporary directory:');
      await for (final entity in tempDir.list(recursive: true)) {
        // Skip if any directory starts with '.'
        if (p.split(entity.path).any((dir) => dir.startsWith('.'))) {
          continue;
        }
        print(entity.path);
      }
      await tempDir.delete(recursive: true);
    });

    test('generates Dart files from .g4 grammar and parses text', () async {
      // Run build_runner
      final buildResult = await Process.run(
        'dart',
        ['run', 'build_runner', 'build', '--verbose'],
        workingDirectory: packagePath,
      );

      print('build_runner Stdout: ${buildResult.stdout}');
      print('build_runner Stderr: ${buildResult.stderr}');
      if (buildResult.exitCode != 0) {
        fail('build_runner failed with exit code ${buildResult.exitCode}');
      }

      final antlrOutputDir = p.join(packagePath, 'lib');
      final lexerFile = File(p.join(antlrOutputDir, 'HelloLexer.dart'));
      final parserFile = File(p.join(antlrOutputDir, 'HelloParser.dart'));
      final listenerFile = File(p.join(antlrOutputDir, 'HelloListener.dart'));
      final baseListenerFile = File(p.join(antlrOutputDir, 'HelloBaseListener.dart'));
      final visitorFile = File(p.join(antlrOutputDir, 'HelloVisitor.dart'));
      final baseVisitorFile = File(p.join(antlrOutputDir, 'HelloBaseVisitor.dart'));

      expect(await lexerFile.exists(), isTrue,
          reason: 'HelloLexer.dart should exist');
      expect(await parserFile.exists(), isTrue,
          reason: 'HelloParser.dart should exist');
      expect(await listenerFile.exists(), isTrue,
          reason: 'HelloListener.dart should exist');
      expect(await baseListenerFile.exists(), isTrue,
          reason: 'HelloBaseListener.dart should exist');
      expect(await visitorFile.exists(), isTrue,
          reason: 'HelloVisitor.dart should exist');
      expect(await baseVisitorFile.exists(), isTrue,
          reason: 'HelloBaseVisitor.dart should exist');

      // Create a small Dart program to test the generated parser
      final testProgramContent = '''
import 'dart:convert';
import 'package:antlr4/antlr4.dart';
import 'package:test_package/HelloLexer.dart';
import 'package:test_package/HelloParser.dart';

void main() {
  final input = InputStream(utf8.encode('abc'));
  final lexer = HelloLexer(input);
  final tokens = BufferedTokenStream(lexer);
  final parser = HelloParser(tokens);

  parser.r(); // Call the 'r' rule

  if (parser.numberOfSyntaxErrors > 0) {
    throw Exception('Parsing failed with errors');
  }
  print('Parsing successful!');
}
''';
      final testProgramFile =
          File(p.join(packagePath, 'bin', 'test_parser.dart'));
      await Directory(p.join(packagePath, 'bin')).create(recursive: true);
      await testProgramFile.writeAsString(testProgramContent);

      // Run the test program
      final runResult = await Process.run(
        'dart',
        ['run', 'bin/test_parser.dart'],
        workingDirectory: packagePath,
      );

      print('test_parser Stdout: ${runResult.stdout}');
      print('test_parser Stderr: ${runResult.stderr}');

      expect(runResult.exitCode, 0,
          reason: 'Test program should run successfully');
      expect(runResult.stdout, contains('Parsing successful!'));
    }, timeout: Timeout.none); // build_runner and dart run can take a while
  });
}
