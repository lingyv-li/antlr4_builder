> **WARNING**: This file is AI generated/maintained. Do not edit manually.

### Project Overview

This project, `antlr4_builder`, is a Dart package designed to integrate ANTLR4 grammar processing with Dart's `build_runner`. It automates the generation of Dart lexer and parser files from `.g4` grammar specifications.

#### Core Components

*   **`AntlrBuilder` (`lib/src/antlr_builder.dart`)**: The central `Builder` class responsible for the ANTLR processing logic.
*   **`antlrBuilder` (`lib/antlr4_builder.dart`)**: The factory function that constructs the `AntlrBuilder`.
*   **`build.yaml`**: The configuration file for `build_runner`, used to enable and configure the ANTLR builder.

#### Key Dependencies

*   **`build`**: Provides the core `Builder` and `Resource` classes.
*   **`http`**: Used for downloading the ANTLR JAR file.
*   **`path`**: For robust path manipulation.
*   **`scratch_space`**: Manages temporary directories and files during the build process.

#### Workflow

1.  The build process is initiated by `build_runner`, targeting `.g4` files.
2.  The builder automatically downloads the required ANTLR JAR version (configurable in `build.yaml`, defaulting to 4.13.2) if it's not already present. The JAR file is managed as a `Resource` to prevent redundant downloads.
3.  A temporary directory is created using `ScratchSpace` to store the generated files from the ANTLR tool.
4.  The ANTLR tool is executed via `java -jar` to generate the Dart source files from the input `.g4` grammar.
5.  The generated Dart files are then read from the scratch space and written to the build output, making them available to the rest of the project.

#### Testing Strategy

*   **`ensure_build_test.dart`**: This test ensures that the build process is clean and that no unexpected files are generated.
*   **`integration_test.dart`**: A comprehensive integration test that validates the end-to-end functionality of the builder. It performs the following steps:
    1.  Creates a temporary Dart package with a sample `.g4` file.
    2.  Configures the `build.yaml` to use the `antlr4_builder`.
    3.  Executes `build_runner` to generate the parser and lexer files.
    4.  Verifies the existence of the generated files.
    5.  Creates and runs a test program that utilizes the generated parser to parse a sample input string, confirming the correctness of the generated code.

### Lessons Learned

During the debugging of the `antlr4_builder` integration test, several key lessons were learned regarding `build_runner` behavior, ANTLR tool usage, and Dart testing practices:

*   **`build_runner` "no-op" Issue**:
    *   If `build_runner` reports "no-op" even when `buildStep.writeAsString` is explicitly called within a builder, it often indicates a mismatch.
    *   Ensure that the `buildExtensions` declared by the builder accurately list all expected output files (e.g., `.lexer.dart`, `.parser.dart`).

*   **ANTLR Tool Output Directory (`-o`) and Directory Structure**:
    *   The ANTLR tool's `-o` argument specifies the output directory for generated files.
    *   This path is interpreted relative to the `workingDirectory` of the `Process.run` command that invokes ANTLR.
    *   **Crucially, the ANTLR tool does not preserve the input file's directory structure when generating output. Files are placed directly in the root of the specified `-o` directory.**
    *   This often necessitates moving generated files within the `ScratchSpace` to match the directory structure expected by `build_runner`'s `buildExtensions`.

*   **`antlr4` Dart Package API**:
    *   The `antlr4` Dart package uses `InputStream` (for character streams) and `BufferedTokenStream` (for token streams).
    *   The older `ANTLRInputStream` and `CommonTokenStream` are not part of the current public API.
    *   When writing test programs or using generated ANTLR code, ensure these correct class names are used.

*   **Dart `test` Package `contains` Matcher**:
    *   The `contains` matcher in Dart's `test` package performs a literal substring match. It does not interpret regular expressions.
    *   When asserting the presence of strings that contain special characters (like `[` or `]`), ensure these characters are properly escaped if you intend a literal match, or use `matches(RegExp(...))` for regular expression-based assertions.

*   **Debugging `build_runner` Builders**:
    *   For more immediate and reliable debugging output from `build_runner` builders, using `print` statements can be more effective than `log.info`.
    *   `print` statements are generally more consistently visible in the console output during `build_runner` execution.

*   **Temporary Package Dependency Management in Tests**:
    *   When integration tests create temporary Dart packages, it's essential to correctly manage their dependencies.
    *   Ensure all necessary packages, including those required by generated code (like `antlr4` for ANTLR-generated Dart files), are listed in the temporary `pubspec.yaml`'s `dependencies` section.
    *   Running `dart pub get` within the temporary package is crucial to resolve these dependencies before attempting to run any scripts or tests that rely on them.

*   **`ScratchSpace` for Temporary File Management**:
    *   `ScratchSpace` from the `scratch_space` package is invaluable for managing temporary files and directories within `build_runner` builders.
    *   It provides a clean, isolated temporary file system for each build step.
    *   When using `ScratchSpace`, ensure that files are placed in the correct `packages/<package_name>/<path_within_package>` structure if they are to be resolved by `buildStep.fetchResource` or `scratchSpace.fileFor` with `AssetId`s.

*   **Configurable Listener/Visitor Generation**:
    *   The `AntlrBuilder` now supports `generate_listener` and `generate_visitor` options in `build.yaml` to control the generation of ANTLR listener and visitor files.
    *   This was implemented by dynamically adjusting the `buildExtensions` based on these boolean flags, ensuring `build_runner` correctly anticipates the generated output files.

*   **Passing Extra ANTLR Arguments (`extra_args`)**:
    *   An `extra_args` option was added to allow users to pass arbitrary arguments directly to the ANTLR tool.
    *   A key challenge encountered was that some ANTLR arguments (e.g., `-atn`) generate additional files with unpredictable names and extensions (e.g., `.dot` files for ATN graphs).
    *   To maintain the integrity of the `build_runner` output and avoid unexpected file generation, the builder is designed to *only* copy `.dart` files from the ANTLR tool's output.
    *   Users should be aware that `extra_args` that generate non-`.dart` files will not have those files included in the build output.

*   **Required `version` Option**:
    *   The `version` option in `build.yaml` is now a required configuration for the `AntlrBuilder`.
    *   This ensures explicit control over the ANTLR JAR version used for code generation.