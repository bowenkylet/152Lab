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

%token PROGRAM FUNCTION BEGIN_PROGRAM END_PROGRAM INTEGER ARRAY OF IF THEN ENDIF ELSE RETURN
%token WHILE DO FOR BEGINLOOP ENDLOOP BREAK CONTINUE READ WRITE AND OR NOT TRUE
%token FALSE MULT DIV MOD EQ NEQ LT GT LTE GTE SEMICOLON COLON COMMA DIGIT SUB
%token L_SQUARE_BRACKET R_SQUARE_BRACKET L_PAREN R_PAREN ASSIGN NUMBER PLUS MINUS IDENTIFIER
%token BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token	<int_val>	INTEGER_LITERAL
/* %type	<int_val>	exp*/
%right ASSIGN
%left OR
%left AND
%right NOT
%left EQ NEQ LT GT LTE GTE
%left MINUS PLUS SUB
%left MULT DIV MOD
%right NEG
%left L_SQUARE_BRACKET R_SQUARE_BRACKET 
%left L_PAREN R_PAREN

%%

Program			: /* empty */	{printf("prog_start -> epsilon\n");}
			| Program Function	{printf("prog_start -> functions\n");}
			;

Function		: FUNCTION IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C	{printf("Function -> IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C\n");}
			| Function FUNCTION IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C	{printf("Function -> Function IDENTIFIER SEMICOLON F_Block_A F_Block_B F_Block_C\n");}
            		;

F_Block_A		: BEGIN_PARAMS Decl_loop END_PARAMS	{printf("F_Block_A -> BEGIN_PARAM Decl_loop END_PARAM\n");}
			;

F_Block_B		: BEGIN_LOCALS Decl_loop END_LOCALS	{printf("F_Block_B -> BEGIN_LOCAL Decl_loop END_LOCAL\n");}
			;

F_Block_C		: BEGIN_BODY Stmt_loop END_BODY		{printf("F_Block_C -> BEGIN_BODY Stmt_loop END_BODY\n");}
			;

Decl_loop		: /*epsilon*/	{printf("Decl_loop -> epsilon\n");}
			| Declaration SEMICOLON Decl_loop	{printf("Decl_loop -> Declaration SEMICOLON Decl_loop\n");}
			;

Stmt_loop		: /*epsilon*/	{printf("stmt_loop -> epsilon\n");}
			| Statement SEMICOLON Stmt_loop		{printf("Stmt_loop -> Statement SEMICOLON Stmt_loop\n");}
			;

Declaration		: Identifier_loop COLON Array_of INTEGER	{printf("Declaration -> Identifier_loop COLON Array_of INTEGER\n");}
			;

Array_of		: /*epsilon*/	{printf("Array_of -> epsilon\n");}
			| ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET Array_lv2 OF	{printf("Array_of -> ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET Array_lv2 OF\n");}
			;

Array_lv2		: /*epsilon*/	{printf("Array_lv2 -> epsilon\n");}
			| L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET	{printf("Array_lv2 -> L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET\n");}
			;

Identifier_loop		: IDENTIFIER	{printf("Identifier_loop -> IDENTIFIER\n");}
			| IDENTIFIER COMMA Identifier_loop	{printf("Identifier_loop -> IDENTIFIER COMMA Identifier_loop\n");}
			;

Statement		: Var ASSIGN Expression	{printf("Statement -> Var ASSIGN Expression\n");}
			| IF Bool_Expr THEN Stmt_loop Statement_else ENDIF	{printf("Statement ->IF Bool-Expr THEN Stmt_loop Statement_else ENDIF\n");}
			| WHILE Bool_Expr BEGINLOOP Stmt_loop ENDLOOP	{printf("Statement -> WHILE Bool-Expr BEGINLOOP Stmt_loop ENDLOOP\n");}
			| DO BEGINLOOP Stmt_loop ENDLOOP WHILE Bool_Expr	{printf("Statement -> DO BEGINLOOP Stmt_loop ENDLOOP WHILE Bool-Expr\n");}
			| FOR Var ASSIGN NUMBER SEMICOLON Bool_Expr SEMICOLON Var ASSIGN Expression BEGINLOOP Stmt_loop ENDLOOP {printf("collapse for loop\n");}
			| READ Var_loop	{printf("Statement -> READ Var_loop\n");}
			| WRITE Var_loop	{printf("Statement -> WRITE Var_loop\n");}
			| CONTINUE	{printf("Statement -> CONTINUE\n");}
			| RETURN Expression	{printf("Statement -> RETURN Expression\n");}
			;

Statement_else		: /*epsilon*/	{printf("Statement_else -> epsilon\n");}
			| ELSE Stmt_loop	{printf("Statement_else -> ELSE Stmt_loop\n");}
			;

Var_loop		: Var	{printf("Var_loop -> Var\n");}
			| Var COMMA Var_loop	{printf("Var -> Var COMMA Var_loop\n");}
			;

Bool_Expr		: Relation_And_Expr Rel_And_Expr_loop 	{printf("Bool-Expr -> Relation-And-Expr Rel_And_Expr_loop\n");}
			;

Rel_And_Expr_loop	: /*epsilon*/	{printf("Rel_And_Expr_loop -> epsilon\n");}
			| OR Relation_And_Expr Rel_And_Expr_loop	{printf("Rel_And_Expr_loop -> OR Relation_And_Expr Rel_And_Expr_loop\n");}
			;

Relation_And_Expr	: Relation_Expr Rel_Expr_loop	{printf("Relation-And-Expr -> Relation-Expr Rel_Expr_loop\n");}
			;

Rel_Expr_loop		: /*epsilon*/	{printf("Rel_Expr_loop -> epsilon\n");}
			| Relation_Expr Rel_Expr_loop	{printf("Rel_Expr_loop -> Relation_Expr Rel_Expr_loop\n");}
			;

Relation_Expr		: NOT Relex_Block	{printf("Relation-Expr -> NOT Relex_Block\n");}
			| Relex_Block	{printf("Relation-Expr -> Relex_Block\n");}
			;

Relex_Block		: Expression Comp Expression	{printf("Relex_Block -> Expression Comp Expression\n");}
			| TRUE	{printf("Relex_Block -> TRUE\n");}
			| FALSE	{printf("Relex_Block -> FALSE\n");}
			| L_PAREN Bool_Expr R_PAREN	{printf("Relex_Block -> L_PAREN Bool-Expr R_PAREN\n");}
			;

Comp			: EQ	{printf("Comp -> EQ\n");}
			| NEQ	{printf("Comp -> NEQ\n");}
			| LT	{printf("Comp -> LT\n");}
			| GT	{printf("Comp -> GT\n");}
			| LTE	{printf("Comp -> LTE\n");}
			| GTE	{printf("Comp -> GTE\n");}
			;

Expression		: Multiplicative_Expr	{printf("Expression -> Multiplicative_Expr\n");}
			| Multiplicative_Expr Addop Expression	{printf("Expression -> Multiplicative-Expr Addop Expression\n");}
			;

Addop			: PLUS	{printf("Addop -> PLUS\n");}
			| MINUS	{printf("Addop -> MINUS\n");}
			;

Multiplicative_Expr	: Term MET	{printf("Multiplicative_Expr -> Term MET\n");}
			;

MET			: /*epsilon*/	{printf("MET -> epsilon\n");}
			| MULT Term MET	{printf("MET -> MULT Term MET\n");}
			| DIV Term MET	{printf("MET -> DIV Term MET\n");}
			| MOD Term MET	{printf("MET -> MOD Term MET\n");}
			;

Term			: Opt_Sub Term_val	{printf("Term -> Term_val\n");}
			| IDENTIFIER L_PAREN Term_exp R_PAREN	{printf("Term -> L_PAREN Term_exp R_PAREN\n");}
			;

Opt_Sub			: /*epsilon*/	{printf("Opt_Sub -> epsilon\n");}
			| SUB	{printf("Opt_Sub -> Sub\n");}
			;

Term_val		: Var	{printf("Term_val -> Var\n");}
			| NUMBER	{printf("Term_val -> NUMBER\n");}
			| L_PAREN Expression R_PAREN	{printf("Term_val L_PAREN Expression R_PAREN\n");}
			;

Term_exp		: /*epsilon*/	{printf("Term_exp -> epsilon\n");}
			| Expression	{printf("Term_exp -> Expression\n");}
			| Expression COMMA Term_exp	{printf("Term_exp -> Expression COMMA Term_exp\n");}
			;

Var			: IDENTIFIER	{printf("Var -> IDENTIFIER\n");}
			| IDENTIFIER L_SQUARE_BRACKET Expression R_SQUARE_BRACKET	{printf("Var -> L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
			;

Var_exp2		: /*epsilon*/	{printf("Var_exp2 -> epsilon");}
			| L_SQUARE_BRACKET Expression R_SQUARE_BRACKET	{printf("Var_exp2 -> L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
			;

%%

int yyerror(char* s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  printf("ERROR: %s at symbol %s", s, yytext);
  printf(" on line %d \n", yylineno);
  exit(1);
}

int main(){
	yyparse();
}
