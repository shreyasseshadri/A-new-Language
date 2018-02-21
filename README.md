# A-new-Language

This is a language created using parse tree,lexical generators `Bison` and `Lex`.<br>

This language supports basic features like `expression evaluation` , `basic arithmetic oprations` , `if ` condition , `while` condition

The CFG used in this language is :<br>
```
    <expr> := [ <op> <expr> <expr> ] | 
                 <symbol> | <value>
    <symbol> := [a-zA-Z]+
    <value> := [0-9]+
    <op> := ‘+’ | ‘*’ | ‘==‘ | ‘<‘
    <prog> := [ = <symbol> <expr> ] |
              [ ; <prog> <prog> ] |
              [ if <expr> <prog> <prog> ] |
              [ while <expr> <prog> ] |
              [ return <expr> ]
```
##  Running the program
To  run this program use:<br>
```
 ./run
```
Permission may need to be given:<br>
```
chmod +x run.sh
```
To clear all the object files and the other generated files use:<br>
```
 ./clear
```
## Reference
[Lex and Yacc Tutorial](http://epaperpress.com/lexandyacc/download/LexAndYaccTutorial.pdf)