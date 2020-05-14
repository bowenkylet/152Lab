%{
#include <stdio.h>
#include <stdlib.h>
int yyerror(char *s);
int yylex(void);
%}

%union{
  int		int_val;
  char*	op_val;
}

 %start	Program 

%token FUNCTION PROGRAM BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE RETURN
%token WHILE DO BEGINLOOP ENDLOOP BREAK CONTINUE READ WRITE AND OR NOT TRUE
%token FALSE MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA DIGIT
%token L_SQUARE_BRACKET R_SQUARE_BRACKET L_PAREN R_PAREN ASSIGN NUMBER PLUS MINUS IDENTIFIER
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token	<int_val>	INTEGER_LITERAL
/* %type	<int_val>	exp*/
%right ASSIGN
%left OR
%left AND
%right NOT
%left EQ NEQ LT GT LTE GTE
%left MINUS PLUS
%left MULT DIV MOD
%right NEG
%left L_SQUARE_BRACKET R_SQUARE_BRACKET 
%left L_PAREN R_PAREN

%%

Program			: /* empty */	//% {printf("prog_start -> epsilon\n");}
			| Program Function	//% {printf("prog_start -> functions\n");}
			;



Function		: FUNCTION IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C //% {printf("Function -> IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C\n");}
			| Function FUNCTION IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C //% {printf("Function -> Function IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C\n");}
            		;

F_Block_A		: BEGIN_PARAMS Fun_Dec END_PARAMS //% {printf("F_Block_A -> BEGIN_PARAM Fun_Dec END_PARAM\n");}
			;

F_Block_B		: BEGIN_LOCALS Fun_Dec END_LOCALS //% {printf("F_Block_B -> BEGIN_LOCAL Fun_Dec END_LOCAL\n");}
			;

F_Block_C		: BEGIN_BODY Fun_State END_BODY //% {printf("F_Block_C -> BEGIN_BODY Statement Fun_State END_BODY\n");}
			;

Fun_Dec			:  //% {printf("declaration -> epsilon\n");}
			| Declaration SEMICOLON Fun_Dec //% {printf("Fun_Dec -> Declaration SEMICOLON Fun_Dec\n");}
			;

Fun_State		: Statement SEMICOLON Fun_State_2 //% {printf("Fun_State -> Statement SEMICOLON Fun_State_2\n");}
			;

Fun_State_2		: /*epsilon*/ //% {printf("statement -> epsilon\n");}
			| Statement SEMICOLON Fun_State_2 //% {printf("Fun_State_2 -> tatement SEMICOLON Fun_State_2\n");}
			;

Declaration		: IDENTIFIER_loop COLON Array_of INTEGER //% {printf("Declaration -> IDENTIFIER_loop COLON Array_of INTEGER\n");}
			;

Array_of		: //% {printf("Array_of -> epsilon\n");}
			| ARRAY L_SQUARE_BRACKET DIGIT R_SQUARE_BRACKET OF //% {printf("Array_of -> ARRAY L_SQUARE_BRACKET DIGIT R_SQUARE_BRACKET OF\n");}
			;

IDENTIFIER_loop		: IDENTIFIER //% {printf("IDENTIFIER_loop -> IDENTIFIER\n");}
			| IDENTIFIER COMMA IDENTIFIER_loop //% {printf("IDENTIFIER_loop -> IDENTIFIER COMMA IDENTIFIER_loop\n");}
			;

Statement		: Var ASSIGN Expression //% {printf("Statement -> Var ASSIGN Expression\n");}
			|IF Bool-Expr THEN Statement_loop Statement_else ENDIF //% {printf("Statement ->IF Bool-Expr THEN Statement_loop Statement_else ENDIF\n");}
			| WHILE Bool-Expr BEGINLOOP Statement_loop ENDLOOP //% {printf("Statement -> WHILE Bool-Expr BEGINLOOP Statement_loop ENDLOOP\n");}
			| DO BEGINLOOP Statement_loop ENDLOOP WHILE Bool-Expr //% {printf("Statement -> DO BEGINLOOP Statement_loop ENDLOOP WHILE Bool-Expr\n");}
			| READ State_Var //% {printf("Statement -> READ State_Var\n");}
			| WRITE State_Var //% {printf("Statement -> WRITE State_Var\n");}
			| CONTINUE //% {printf("Statement -> CONTINUE\n");}
			| RETURN Expression //% {printf("Statement -> RETURN Expression\n");}
			;

Statement_else		: //% {printf("Statement_else -> epsilon\n");}
			| ELSE Statement_loop //% {printf("Statement_else -> ELSE Statement_loop\n");}
			;

Statement_loop		: Statement SEMICOLON //% {printf("Statement_loop -> Statement SEMICOLON\n");}
			| Statement	SEMICOLON Statement_loop //% {printf("Statement_loop -> Statement	SEMICOLON Statement_loop\n");}
			;

State_Var		: Var //% {printf("State_Var -> Var\n");}
			| Var COMMA State_Var //% {printf("State_Var -> Var COMMA State_Var\n");}
			;

Bool-Expr		: Relation-And-Expr //% {printf("Bool-Expr -> Relation-And-Expr\n");}
			| Relation-Expr OR Bool-Expr //% {printf("Bool-Expr -> Relation-Expr OR Bool-Expr\n");}
			;

Relation-And-Expr	: Relation-Expr //% {printf("Relation-And-Expr -> Relation-Expr\n");}
			| Relation-Expr AND Relation-And-Expr //% {printf("Relation-And-Expr -> Relation-Expr AND Relation-And-Expr\n");}
			;

Relation-Expr		: NOT Relex_Block //% {printf("Relation-Expr -> NOT Relex_Block\n");}
			| Relex_Block //% {printf("Relation-Expr -> Relex_Block\n");}
			;

Relex_Block		: Expression Comp Expression //% {printf("Relex_Block -> Expression Comp Expression\n");}
			| TRUE //% {printf("Relex_Block -> TRUE\n");}
			| FALSE //% {printf("Relex_Block -> FALSE\n");}
			| L_PAREN Bool-Expr R_PAREN //% {printf("Relex_Block -> L_PAREN Bool-Expr R_PAREN\n");}
			;

Comp			: EQ //% {printf("Comp -> EQ\n");}
			| NEQ //% {printf("Comp -> NEQ\n");}
			| LT //% {printf("Comp -> LT\n");}
			| GT //% {printf("Comp -> GT\n");}
			| LTE //% {printf("Comp -> LTE\n");}
			| GTE //% {printf("Comp -> GTE\n");}
			;

Expression		: Multiplicative-Expr //% {printf("Expression -> Multiplicative-Expr\n");}
			| Multiplicative-Expr PLUS Expression //% {printf("Expression -> Multiplicative-Expr PLUS Expression\n");}
			| Multiplicative-Expr MINUS Expression //% {printf("Expression -> Multiplicative-Expr MINUS Expression\n");}
			;

Multiplicative-Expr	: Term MET //% {printf("Multiplicative-Expr -> Term MET\n");}
			;

MET			: //% {printf("MET -> epsilon\n");}
			| MULT Term MET //% {printf("MET -> MULT Term MET\n");}
			| DIV Term MET //% {printf("MET -> DIV Term MET\n");}
			| MOD Term MET //% {printf("MET -> MOD Term MET\n");}
			;

Term			: Term_val //% {printf("Term -> Term_val\n");}
			| IDENTIFIER L_PAREN Term_exp R_PAREN //% {printf("Term -> L_PAREN Term_exp R_PAREN\n");}
			;

Term_val		: Var //% {printf("Term_val -> Var\n");}
			| NUMBER //% {printf("Term_val -> NUMBER\n");}
			| L_PAREN Expression R_PAREN //% {printf("Term_val L_PAREN Expression R_PAREN\n");}
			;

Term_exp		: //% {printf("Term_exp -> epsilon\n");}
			| Expression //% {printf("Term_exp -> Expression\n");}
			| Expression COMMA Term_exp //% {printf("Term_exp -> Expression COMMA Term_exp\n");}
			;

Var			: IDENTIFIER //% {printf("Var -> IDENTIFIER\n");}
			| IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET //% {printf("Var -> L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
			;

%%

int main(){
yyparse();
}

int yyerror(char* s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  printf("ERROR: %s at symbol %s", s, yytext);
  printf(" on line %d \n", yylineno);
  exit(1);
}


