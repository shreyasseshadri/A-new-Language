#include <stdio.h>
#include "yacc.h"
#include "y.tab.h"

int execute(nodeType *p) {
    if (!p) return 0;
    switch(p->type) {
    case typeConstant:       return p->con.value;
    case typeIdentifier:        return sym[p->id.i];
    case typeOperation:
        switch(p->opr.oper) {
        case WHILE:     while(execute(p->opr.op[0])) execute(p->opr.op[1]); return 0;
        case IF:        if (execute(p->opr.op[0]))
                            execute(p->opr.op[1]);
                        execute(p->opr.op[2]);
                        return 0;
        case PRINT:     printf("%d\n\n", execute(p->opr.op[0])); return 0;
        case ';':       execute(p->opr.op[0]); return execute(p->opr.op[1]);
        case '=':       return sym[p->opr.op[0]->id.i] = execute(p->opr.op[1]);
        case '+':       return execute(p->opr.op[0]) + execute(p->opr.op[1]);
        case '*':       return execute(p->opr.op[0]) * execute(p->opr.op[1]);
        case '<':       return execute(p->opr.op[0]) < execute(p->opr.op[1]);
        case EQ:        return execute(p->opr.op[0]) == execute(p->opr.op[1]);
        }
    }
    return 0;
}
