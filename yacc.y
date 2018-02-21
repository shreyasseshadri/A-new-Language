%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "yacc.h"

/* prototypes */
nodeType *operate(int oper, int nops, ...);
nodeType *id(int i);
nodeType *con(int value);
void freeNode(nodeType *p);
int execute(nodeType *p);
int yylex(void);

void yyerror(char *s);
int sym[26];                    /* symbol table */
%}

%union {
    int number;                 /* integer value */
    char sIndex;                /* symbol table index */
    nodeType *nPtr;             /* node pointer */
};

%token <number> INTEGER
%token <sIndex> VARIABLE
%token WHILE IF RETURN PRINT EQ

%type <nPtr> prog expr

%%

start:
        prog    { execute($1); freeNode($1); } start
        | expr            { printf("%d\n\n", execute($1)); } start
        | /* NULL */
        ;

prog:
         '[' ';' prog prog ']'          { $$ = operate(';', 2, $3, $4); }
        | '[' RETURN expr ']'                 { $$ = operate(PRINT, 1, $3); }
        | '[' '=' VARIABLE expr ']'          { $$ = operate('=', 2, id($3), $4); }
        | '[' WHILE expr prog ']'        { $$ = operate(WHILE, 2, $3, $4); }
        | '[' IF expr prog prog ']' { $$ = operate(IF, 3, $3, $4, $5); }
        ;

expr:
        INTEGER               { $$ = con($1); }
        | VARIABLE              { $$ = id($1); }
        | '[' '+' expr expr ']'         { $$ = operate('+', 2, $3, $4); }
        | '[' '*' expr expr ']'         { $$ = operate('*', 2, $3, $4); }
        | '[' '<' expr expr ']'        { $$ = operate('<', 2, $3, $4); }
        | '[' EQ expr expr ']'        { $$ = operate(EQ, 2, $3, $4); }
        ;

%%

nodeType *con(int value) {
    nodeType *p;

    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
    p->type = typeConstant;
    p->con.value = value;

    return p;
}

nodeType *id(int i) {
    nodeType *p;
    if ((p = malloc(sizeof(nodeType))) == NULL)
        yyerror("out of memory");
    p->type = typeIdentifier;
    p->id.i = i;

    return p;
}

nodeType *operate(int oper, int nops, ...) {
    va_list ap;
    nodeType *p;
    int i;

    if ((p = malloc(sizeof(nodeType) + (nops-1) * sizeof(nodeType *))) == NULL)
        yyerror("out of memory");

    p->type = typeOperation;
    p->opr.oper = oper;
    p->opr.nops = nops;
    va_start(ap, nops);
    for (i = 0; i < nops; i++)
        p->opr.op[i] = va_arg(ap, nodeType*);
    va_end(ap);
    return p;
}

void freeNode(nodeType *p) {
    int i;

    if (!p) return;
    if (p->type == typeOperation) {
        for (i = 0; i < p->opr.nops; i++)
            freeNode(p->opr.op[i]);
    }
    free (p);
}
void yyerror(char *s) {
    extern char* yytext;
    extern int yylineno;
    fprintf(stdout, "%s\nLine No: %d\nAt char: %c\n", s, yylineno,*yytext);
}
int main(void) {
    yyparse();
    return 0;
}
