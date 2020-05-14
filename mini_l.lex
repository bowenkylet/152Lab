%{
#include <stdio.h>
float string2float(char* str);
int countNums = 0;
int countOperators = 0;
int countParens = 0;
int countEquals = 0;
int currpos = 1;
int currline = 1;

%}

COMMENT		##.*
LETTER		[a-zA-Z]
DIGIT           [0-9]
INT             {DIGIT}+
NUMBER  	{INT}
IDENT           {LETTER}+({LETTER}|{DIGIT}|[_])*({LETTER}|{DIGIT})*
IDENT_ERR1      ({DIGIT}|[_])({LETTER}|{DIGIT}|[_])*({LETTER}|{DIGIT})
IDENT_ERR2      {LETTER}+({LETTER}|{DIGIT}|[_])*[_]
%%

{COMMENT}
[ \t]+          {currpos+=yyleng;}
"function"      {printf("FUNCTION\n");currpos+=yyleng;}
"beginparams"   {printf("BEGIN_PARAMS\n");currpos+=yyleng;}
"endparams"     {printf("END_PARAMS\n");currpos+=yyleng;}
"beginlocals"   {printf("BEGIN_LOCALS\n");currpos+=yyleng;}
"endlocals"     {printf("END_LOCALS\n");currpos+=yyleng;}
"beginbody"     {printf("BEGIN_BODY\n");currpos+=yyleng;}
"endbody"       {printf("END_BODY\n");currpos+=yyleng;}
"integer"       {printf("INTEGER\n");currpos+=yyleng;}
"array"         {printf("ARRAY\n");currpos+=yyleng;}
"of"            {printf("OF\n");currpos+=yyleng;}
"if"            {printf("IF\n");currpos+=yyleng;}
"then"          {printf("THEN\n");currpos+=yyleng;}
"endif"         {printf("ENDIF\n");currpos+=yyleng;}
"else"          {printf("ELSE\n");currpos+=yyleng;}
"while"         {printf("WHILE\n");currpos+=yyleng;}
"do"            {printf("DO\n");currpos+=yyleng;}
"for"           {printf("FOR\n");currpos+=yyleng;}
"beginloop"     {printf("BEGINLOOP\n");currpos+=yyleng;}
"endloop"       {printf("ENDLOOP\n");currpos+=yyleng;}
"continue"      {printf("CONTINUE\n");currpos+=yyleng;}
"read"          {printf("READ\n");currpos+=yyleng;}
"write"         {printf("WRITE\n");currpos+=yyleng;}
"and"           {printf("AND\n");currpos+=yyleng;}
"or"            {printf("OR\n");currpos+=yyleng;}
"not"           {printf("NOT\n");currpos+=yyleng;}
"true"          {printf("TRUE\n");currpos+=yyleng;}
"false"         {printf("FALSE\n");currpos+=yyleng;}
"return"        {printf("RETURN\n");currpos+=yyleng;}

"-"             {printf("SUB\n");currpos+=yyleng;}
"+"             {printf("ADD\n");currpos+=yyleng;}
"*"             {printf("MULT\n");currpos+=yyleng;}
"/"             {printf("DIV\n");currpos+=yyleng;}
"%"             {printf("MOD\n");currpos+=yyleng;}


"=="            {printf("EQ\n");currpos+=yyleng;}
"<>"            {printf("NEQ\n");currpos+=yyleng;}
"<"             {printf("LT\n");currpos+=yyleng;}
">"             {printf("GT\n");currpos+=yyleng;}
"<="            {printf("LTE\n");currpos+=yyleng;}
">="            {printf("GTE\n");currpos+=yyleng;}

";"             {printf("SEMICOLON\n");currpos+=yyleng;}
":"             {printf("COLON\n");currpos+=yyleng;}
","             {printf("COMMA\n");currpos+=yyleng;}
"("             {printf("L_PAREN\n");currpos+=yyleng;}
")"             {printf("R_PAREN\n");currpos+=yyleng;}
"["             {printf("L_SQUARE_BRACKET\n");currpos+=yyleng;}
"]"             {printf("R_SQUARE_BRACKET\n");currpos+=yyleng;}
":="            {printf("ASSIGN\n");currpos+=yyleng;}

{NUMBER}                {printf("NUMBER %s\n",yytext); currpos+=yyleng;countNums++;}
{IDENT_ERR1}            {printf("identifier \"%s\" must begin with a letter",yytext); currpos+=yyleng;}
{IDENT_ERR2}            {printf("identifier \"%s\" cannot end with an underscore",yytext); currpos+=yyleng;}
{IDENT}                 {printf("IDENT %s\n",yytext); currpos+=yyleng;}

\n                      {currline++;currpos=1;}
.               {printf("unrecognized character\n");currpos+=yyleng;return 1;}

%%

float string2float(char* str) {
        return 0.0f;
}

int main(int argc, char *argv[]) {
        yyin = fopen(argv[1],"r");
        yylex();
        return 0;
}


