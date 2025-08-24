import 'dart:async';
import 'dart:io';
import 'package:build/build.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:scratch_space/scratch_space.dart';

final _scratchSpaceResource =
    Resource(() => ScratchSpace(), dispose: (old) => old.delete());

class AntlrBuilder implements Builder {
  final Resource<File> antlrJarResource;
  final bool generateListener;
  final bool generateVisitor;
  final List<String> extraArgs;

  AntlrBuilder(this.antlrJarResource,
      {this.generateListener = true,
      this.generateVisitor = false,
      this.extraArgs = const []});

  static AntlrBuilder fromJson(Map<String, dynamic> config) {
    final antlrVersion = config['version'] as String?;
    if (antlrVersion == null) {
      throw ArgumentError.notNull('version in build.yaml');
    }
    final antlrJarResource = AntlrBuilder.createAntlrJarResource(antlrVersion);
    return AntlrBuilder(antlrJarResource,
        generateListener: config['generate_listener'] as bool? ?? true,
        generateVisitor: config['generate_visitor'] as bool? ?? false,
        extraArgs:
            (config['extra_args'] as List<dynamic>? ?? []).cast<String>());
  }

  static Resource<File> createAntlrJarResource(String antlrVersion) {
    Directory? tempDir;
    return Resource<File>(
      () async {
        tempDir = Directory.systemTemp.createTempSync('antlr_builder_');
        final downloadedAntlrJarPath =
            p.join(tempDir!.path, 'antlr-$antlrVersion-complete.jar');
        final antlrJarUrl =
            'https://www.antlr.org/download/antlr-$antlrVersion-complete.jar';

        // This check is not strictly necessary if we always create a new temp dir
        // but it's good practice.
        if (!await File(downloadedAntlrJarPath).exists()) {
          log.info(
              'Downloading ANTLR $antlrVersion JAR to $downloadedAntlrJarPath...');
          final response = await http.get(Uri.parse(antlrJarUrl));
          if (response.statusCode == 200) {
            await File(downloadedAntlrJarPath).writeAsBytes(response.bodyBytes);
            log.info('ANTLR $antlrVersion JAR downloaded.');
          } else {
            log.severe(
                'Failed to download ANTLR JAR at $antlrJarUrl. Status code: ${response.statusCode}');
            throw Exception('Failed to download ANTLR JAR');
          }
        }
        return File(downloadedAntlrJarPath);
      },
      dispose: (file) async {
        if (tempDir != null && await tempDir!.exists()) {
          await tempDir!.delete(recursive: true);
        }
      },
    );
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.g4': [
          'Lexer.dart',
          'Parser.dart',
          'Listener.dart',
          'BaseListener.dart',
          'Visitor.dart',
          'BaseVisitor.dart',
        ],
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    if (inputId.extension != '.g4') {
      return;
    }

    final scratchSpace = await buildStep.fetchResource(_scratchSpaceResource);
    final antlrJarFile = await buildStep.fetchResource(antlrJarResource);

    // Copy the input .g4 file into the scratch space.
    await scratchSpace.ensureAssets([inputId], buildStep);
    final inputGrammarFile = scratchSpace.fileFor(inputId);

    // The ANTLR tool will output directly into the scratch space's temporary directory.
    final antlrOutputAbsolutePath = p.dirname(inputGrammarFile.path);

    final processResult = await Process.run(
      'java',
      [
        '-jar',
        antlrJarFile.path,
        '-Dlanguage=Dart',
        '-o',
        antlrOutputAbsolutePath,
        '-Xexact-output-dir',
        generateListener ? '-listener' : '-no-listener',
        generateVisitor ? '-visitor' : '-no-visitor',
        // Use the path of the grammar file inside the scratch space.
        p.basename(inputGrammarFile.path),
        ...extraArgs,
      ],
      // The working directory can be the scratch space temp dir now.
      workingDirectory: p.dirname(scratchSpace.fileFor(inputId).path),
    );

    log.info('ANTLR tool stdout: ${processResult.stdout}');
    log.info('ANTLR tool stderr: ${processResult.stderr}');
    if (processResult.exitCode != 0) {
      throw Exception('ANTLR tool failed: ${processResult.stderr}');
    }

    // Read generated files and write them to the build step
    final generatedFiles = Directory(antlrOutputAbsolutePath)
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    for (final sourceFile in generatedFiles) {
      // The final output AssetId for the build step.
      final outputAssetId = AssetId(
        inputId.package,
        p.join(p.dirname(inputId.path), p.basename(sourceFile.path)),
      );

      log.info('Writing ${sourceFile.path} to ${outputAssetId.path}');
      // Copy output to buildStep.
      await scratchSpace.copyOutput(outputAssetId, buildStep);
    }
    log.info('Finished processing generated files.');
  }
}
