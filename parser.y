%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char* name;
    int value;
} variable;

variable symtable[100];
int symtable_count = 0;

// Declaraciones de las funciones
void assign_variable(char* name, int value);
int lookup_variable(char* name);

void yyerror(const char *s);
int yylex();
%}

%union {
    int num;
    char* str;
}

%token <str> IDENTIFIER
%token <num> NUMBER
%token PRINT INPUT
%token <str> STRING
%token FUNCTION VAR CONST IF ELSE WHILE DO FOR
%token ASSIGN SEMICOLON LBRACE RBRACE LPAREN RPAREN
%token PLUS MINUS MULTIPLY DIVIDE MODULO
%token LT GT LE GE EQUALS NEQUALS
%token AND OR NOT

%type <num> expression

%left OR
%left AND
%nonassoc EQUALS NEQUALS
%nonassoc LT GT LE GE
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO
%right NOT

%%

program:
    program statement
    | /* vacío */
    ;

statement:
    variable_declaration
    | function_declaration
    | assignment_statement
    | print_statement
    | input_statement
    ;

variable_declaration:
    VAR IDENTIFIER SEMICOLON
        { assign_variable($2, 0); printf("Variable declaration: %s\n", $2); }
  | CONST IDENTIFIER SEMICOLON
        { assign_variable($2, 0); printf("Constant declaration: %s\n", $2); }
  ;

print_statement:
    PRINT expression SEMICOLON
        { printf("%d", $2); }
  | PRINT STRING SEMICOLON
        {
            char* str = strdup($2);
            // Remover las comillas
            str[strlen(str) - 1] = '\0';
            printf("%s", str + 1);
            free(str);
        }
  ;

input_statement:
    INPUT IDENTIFIER SEMICOLON
        {
            int value;
            printf("Entry for %s: ", $2);
            scanf("%d", &value);
            assign_variable($2, value);
            printf("Assignment: %s = %d\n", $2, value);
        }
  ;

function_declaration:
    FUNCTION IDENTIFIER LPAREN RPAREN LBRACE program RBRACE
        { printf("Function: %s\n", $2); }
    ;

assignment_statement:
    IDENTIFIER ASSIGN expression SEMICOLON
        { assign_variable($1, $3); printf("Assignment: %s = %d\n", $1, $3); }
  ;

expression:
    expression PLUS expression       { $$ = $1 + $3; }
  | expression MINUS expression      { $$ = $1 - $3; }
  | expression MULTIPLY expression   { $$ = $1 * $3; }
  | expression DIVIDE expression     { $$ = $1 / $3; }
  | expression MODULO expression     { $$ = $1 % $3; }
  | expression LT expression         { $$ = $1 < $3; }
  | expression GT expression         { $$ = $1 > $3; }
  | expression LE expression         { $$ = $1 <= $3; }
  | expression GE expression         { $$ = $1 >= $3; }
  | expression EQUALS expression     { $$ = $1 == $3; }
  | expression NEQUALS expression    { $$ = $1 != $3; }
  | expression AND expression        { $$ = $1 && $3; }
  | expression OR expression         { $$ = $1 || $3; }
  | NOT expression                   { $$ = !$2; }
  | LPAREN expression RPAREN         { $$ = $2; }
  | NUMBER                           { $$ = $1; }
  | IDENTIFIER                       { $$ = lookup_variable($1); }
  ;

%%

int lookup_variable(char* name) {
    for (int i = 0; i < symtable_count; i++) {
        if (strcmp(symtable[i].name, name) == 0) {
            return symtable[i].value;
        }
    }
    fprintf(stderr, "Error: Variable '%s' not declared.\n", name);
    exit(1);
}

void assign_variable(char* name, int value) {
    for (int i = 0; i < symtable_count; i++) {
        if (strcmp(symtable[i].name, name) == 0) {
            symtable[i].value = value;
            return;
        }
    }
    // Si no existe, agregarla
    symtable[symtable_count].name = strdup(name);
    symtable[symtable_count].value = value;
    symtable_count++;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    return yyparse();
}
