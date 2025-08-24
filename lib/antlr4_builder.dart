import 'package:build/build.dart';
import 'package:antlr4_builder/src/antlr_builder.dart';

Builder antlrBuilder(BuilderOptions options) =>
    AntlrBuilder.fromJson(options.config);
