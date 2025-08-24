// Generated from Example.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExampleParser.dart';

/// This abstract class defines a complete listener for a parse tree produced by
/// [ExampleParser].
abstract class ExampleListener extends ParseTreeListener {
  /// Enter a parse tree produced by [ExampleParser.program].
  /// [ctx] the parse tree
  void enterProgram(ProgramContext ctx);
  /// Exit a parse tree produced by [ExampleParser.program].
  /// [ctx] the parse tree
  void exitProgram(ProgramContext ctx);

  /// Enter a parse tree produced by [ExampleParser.statement].
  /// [ctx] the parse tree
  void enterStatement(StatementContext ctx);
  /// Exit a parse tree produced by [ExampleParser.statement].
  /// [ctx] the parse tree
  void exitStatement(StatementContext ctx);
}