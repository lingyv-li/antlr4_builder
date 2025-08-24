grammar Example;
program : statement+ EOF;
statement : 'hello' ID ';';
ID : [a-zA-Z]+;
WS : [ \t\r\n]+ -> skip;
