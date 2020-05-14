parser:		mini_l.lex
		flex mini_l.lex
		gcc -o lexer lex.yy.c -lfl

clean:
		rm -f lex.yy.c lexer *.tab.c *.tab.h *.output

fibonacci:
		flex mini_l.lex
		gcc -o lexer lex.yy.c -lfl
		cat fibonacci.min | ./lexer

mytest:
		flex mini_l.lex
		gcc -o lexer lex.yy.c -lfl
		cat mytest.min | ./lexer

primes:
		flex mini_l.lex
		gcc -o lexer lex.yy.c -lfl
		cat primes.min | ./lexer

bison:
		bison -d -v mini_l.y
		flex mini_l.lex
		gcc mini_l.tab.c lex.yy.c -lfl -o parser

test:
		cat primes.min | parser
