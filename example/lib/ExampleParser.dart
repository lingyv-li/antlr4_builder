// Generated from Example.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'ExampleListener.dart';
import 'ExampleBaseListener.dart';
import 'ExampleVisitor.dart';
import 'ExampleBaseVisitor.dart';
const int RULE_program = 0, RULE_statement = 1;
class ExampleParser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.13.2', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_T__0 = 1, TOKEN_T__1 = 2, TOKEN_ID = 3, TOKEN_WS = 4;

  @override
  final List<String> ruleNames = [
    'program', 'statement'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'hello'", "';'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, null, null, "ID", "WS"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'Example.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  ExampleParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  ProgramContext program() {
    dynamic _localctx = ProgramContext(context, state);
    enterRule(_localctx, 0, RULE_program);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 5; 
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      do {
        state = 4;
        statement();
        state = 7; 
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      } while (_la == TOKEN_T__0);
      state = 9;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  StatementContext statement() {
    dynamic _localctx = StatementContext(context, state);
    enterRule(_localctx, 2, RULE_statement);
    try {
      enterOuterAlt(_localctx, 1);
      state = 11;
      match(TOKEN_T__0);
      state = 12;
      match(TOKEN_ID);
      state = 13;
      match(TOKEN_T__1);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  static const List<int> _serializedATN = [
      4,1,4,16,2,0,7,0,2,1,7,1,1,0,4,0,6,8,0,11,0,12,0,7,1,0,1,0,1,1,1,1,
      1,1,1,1,1,1,0,0,2,0,2,0,0,14,0,5,1,0,0,0,2,11,1,0,0,0,4,6,3,2,1,0,
      5,4,1,0,0,0,6,7,1,0,0,0,7,5,1,0,0,0,7,8,1,0,0,0,8,9,1,0,0,0,9,10,5,
      0,0,1,10,1,1,0,0,0,11,12,5,1,0,0,12,13,5,3,0,0,13,14,5,2,0,0,14,3,
      1,0,0,0,1,7
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class ProgramContext extends ParserRuleContext {
  TerminalNode? EOF() => getToken(ExampleParser.TOKEN_EOF, 0);
  List<StatementContext> statements() => getRuleContexts<StatementContext>();
  StatementContext? statement(int i) => getRuleContext<StatementContext>(i);
  ProgramContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_program;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is ExampleListener) listener.enterProgram(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is ExampleListener) listener.exitProgram(this);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExampleVisitor<T>) {
     return visitor.visitProgram(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

class StatementContext extends ParserRuleContext {
  TerminalNode? ID() => getToken(ExampleParser.TOKEN_ID, 0);
  StatementContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_statement;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is ExampleListener) listener.enterStatement(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is ExampleListener) listener.exitStatement(this);
  }
  @override
  T? accept<T>(ParseTreeVisitor<T> visitor) {
    if (visitor is ExampleVisitor<T>) {
     return visitor.visitStatement(this);
    } else {
    	return visitor.visitChildren(this);
    }
  }
}

