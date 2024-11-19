%{
#include "parser.tab.h" // Incluye los tokens generados por Bison
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap

%%

[ \t\n\r]+             ;   // Ignorar espacios y saltos de línea
"print"                { return PRINT; }
"input"                { return INPUT; }
"function"             { return FUNCTION; }
"var"                  { return VAR; }
"const"                { return CONST; }
"if"                   { return IF; }
"else"                 { return ELSE; }
"while"                { return WHILE; }
"do"                   { return DO; }
"for"                  { return FOR; }
\"[^\"]*\"             { yylval.str = strdup(yytext); return STRING; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }
[0-9]+(\.[0-9]+)?      { yylval.num = atof(yytext); return NUMBER; }
";"                    { return SEMICOLON; }
"{"                    { return LBRACE; }
"}"                    { return RBRACE; }
"("                    { return LPAREN; }
")"                    { return RPAREN; }
"//".*                 ; // Ignorar comentarios de una línea
"=="                    { return EQUALS; }
"!="                    { return NEQUALS; }
"<="                    { return LE; }
">="                    { return GE; }
"&&"                    { return AND; }
"||"                    { return OR; }
"+"                     { return PLUS; }
"-"                     { return MINUS; }
"*"                     { return MULTIPLY; }
"/"                     { return DIVIDE; }
"%"                     { return MODULO; }
"<"                     { return LT; }
">"                     { return GT; }
"="                     { return ASSIGN; }
"!"                     { return NOT; }
.                      { return yytext[0]; } // Otros caracteres

%%

