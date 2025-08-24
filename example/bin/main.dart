import 'dart:convert';
import 'package:antlr4/antlr4.dart';
import 'package:antlr4_builder_example/ExampleLexer.dart';
import 'package:antlr4_builder_example/ExampleParser.dart';

void main() {
  final input = InputStream.fromString('hello world; hello dart;');
  final lexer = ExampleLexer(input);
  final tokens = CommonTokenStream(lexer);
  final parser = ExampleParser(tokens);

  try {
    parser.program();
    if (parser.numberOfSyntaxErrors > 0) {
      print('Parsing failed with errors.');
    } else {
      print('Parsing successful!');
    }
  } catch (e) {
    print('An error occurred during parsing: $e');
  }
}
