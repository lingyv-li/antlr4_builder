// Generated from Example.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExampleParser.dart';

/// This abstract class defines a complete generic visitor for a parse tree
/// produced by [ExampleParser].
///
/// [T] is the eturn type of the visit operation. Use `void` for
/// operations with no return type.
abstract class ExampleVisitor<T> extends ParseTreeVisitor<T> {
  /// Visit a parse tree produced by [ExampleParser.program].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitProgram(ProgramContext ctx);

  /// Visit a parse tree produced by [ExampleParser.statement].
  /// [ctx] the parse tree.
  /// Return the visitor result.
  T? visitStatement(StatementContext ctx);
}