%{
#include "y.tab.h"
int yylex(void);
%}

%%

SELECT     { return SELECT; }
FROM       { return FROM; }
WHERE      { return WHERE; }
AND        { return AND; }
OR         { return OR; }
[ \t\n]+   ; // Ignore whitespace
.          ; // Ignore other characters

%%

int yywrap(void) {
    return 1;
}