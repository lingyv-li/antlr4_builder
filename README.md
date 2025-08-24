# antlr4_builder

A Dart package that integrates ANTLR4 grammar processing into the `build_runner` ecosystem, allowing you to automatically generate Dart lexer and parser files from your ANTLR4 grammars.

## Features

*   **Automated Code Generation**: Automatically generates Dart lexer, parser, listener, and base listener files from `.g4` grammar files during the build process.
*   **`build_runner` Integration**: Seamlessly integrates with Dart's `build_runner` for efficient and incremental builds.
*   **ANTLR JAR Management**: Automatically downloads the necessary ANTLR4 JAR if not already present, simplifying setup.
*   **Temporary File Management**: Utilizes `ScratchSpace` for robust and clean management of temporary files generated during the ANTLR processing.
*   **Configurable ANTLR Version**: Allows specifying the ANTLR version to use for code generation.

## Getting started

### Prerequisites

*   Java Development Kit (JDK) (required for the ANTLR tool)
*   Dart SDK (version 3.0.0 or higher)
*   `build_runner` in your project's `dev_dependencies`.

### Installation

Add `antlr4_builder` to your project's `pubspec.yaml` under `dependencies`:

```yaml
dependencies:
  antlr4_builder: ^1.0.0 # Replace with the actual latest version
  antlr4: ^4.13.0 # Required for generated ANTLR code
```

And add `build_runner` to your `dev_dependencies`:

```yaml
dev_dependencies:
  build_runner: ^2.0.0 # Replace with the actual latest version
```

Run `dart pub get` to fetch the new dependencies.

### Configuration

Create or update your `build.yaml` file in the root of your project to enable the `antlr4_builder`:

```yaml
targets:
  $default:
    builders:
      antlr4_builder|antlrBuilder:
        enabled: true
        options:
          # Specify the ANTLR version to use
          version: "4.13.2" 
          # Other options
          # ...
          # generate_listener: true
          # generate_visitor: true
          # extra_args: ["-Werror"]
```

### Configuration Options

The following options can be configured in your `build.yaml` under the `options` key:

*   `version`: (String, required) Specifies the version of the ANTLR tool to use.
*   `generate_listener`: (boolean, optional) Controls whether to generate a parse tree listener. Defaults to `true`. Corresponds to the ANTLR `-listener` and `-no-listener` flags.
*   `generate_visitor`: (boolean, optional) Controls whether to generate a parse tree visitor. Defaults to `false`. Corresponds to the ANTLR `-visitor` and `-no-visitor` flags.
*   `extra_args`: (List<String>, optional) A list of additional arguments to pass directly to the ANTLR tool. Defaults to an empty list.

## Usage

For a complete example, refer to the `example/` directory in this repository.

## Running the Example

To run the example project:

1.  Navigate to the `example` directory:
    ```bash
    cd example
    ```
2.  Fetch the example project's dependencies:
    ```bash
    dart pub get
    ```
3.  Run `build_runner` to generate the ANTLR Dart files:
    ```bash
    dart run build_runner build
    ```
4.  Run the example application:
    ```bash
    dart run bin/main.dart
    ```
    You should see "Parsing successful!" in the console output.
