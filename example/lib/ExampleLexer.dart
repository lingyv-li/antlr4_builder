// Generated from Example.g4 by ANTLR 4.13.2
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';


class ExampleLexer extends Lexer {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.13.2', RuntimeMetaData.VERSION);

  static final List<DFA> _decisionToDFA = List.generate(
        _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int
    TOKEN_T__0 = 1, TOKEN_T__1 = 2, TOKEN_ID = 3, TOKEN_WS = 4;
  @override
  final List<String> channelNames = [
    'DEFAULT_TOKEN_CHANNEL', 'HIDDEN'
  ];

  @override
  final List<String> modeNames = [
    'DEFAULT_MODE'
  ];

  @override
  final List<String> ruleNames = [
    'T__0', 'T__1', 'ID', 'WS'
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


  ExampleLexer(CharStream input) : super(input) {
    interpreter = LexerATNSimulator(_ATN, _decisionToDFA, _sharedContextCache, recog: this);
  }

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  String get grammarFileName => 'Example.g4';

  @override
  ATN getATN() { return _ATN; }

  static const List<int> _serializedATN = [
      4,0,4,29,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,1,0,1,0,1,0,1,0,1,0,
      1,0,1,1,1,1,1,2,4,2,19,8,2,11,2,12,2,20,1,3,4,3,24,8,3,11,3,12,3,25,
      1,3,1,3,0,0,4,1,1,3,2,5,3,7,4,1,0,2,2,0,65,90,97,122,3,0,9,10,13,13,
      32,32,30,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,1,9,1,0,0,
      0,3,15,1,0,0,0,5,18,1,0,0,0,7,23,1,0,0,0,9,10,5,104,0,0,10,11,5,101,
      0,0,11,12,5,108,0,0,12,13,5,108,0,0,13,14,5,111,0,0,14,2,1,0,0,0,15,
      16,5,59,0,0,16,4,1,0,0,0,17,19,7,0,0,0,18,17,1,0,0,0,19,20,1,0,0,0,
      20,18,1,0,0,0,20,21,1,0,0,0,21,6,1,0,0,0,22,24,7,1,0,0,23,22,1,0,0,
      0,24,25,1,0,0,0,25,23,1,0,0,0,25,26,1,0,0,0,26,27,1,0,0,0,27,28,6,
      3,0,0,28,8,1,0,0,0,3,0,20,25,1,6,0,0
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}