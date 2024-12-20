# Compilador Tornado

- **Profesor**: José Veas Muñoz  
- **Integrantes**:  
  - Ignacio Hernández  
  - Anais Rodríguez  
  - Tomás Vargas  
- **Fecha**: 06 de diciembre del 2024
---

# Documentación Técnica del Compilador Tornado

## Descripción de la Gramática del Lenguaje

El compilador Tornado es un proyecto educativo diseñado para implementar un lenguaje de programación básico que incluye características fundamentales como declaración de variables, entrada/salida, operaciones aritméticas y estructuras de control simples. El proyecto utiliza Flex para el análisis léxico y Bison para el análisis sintáctico.

## Características del Lenguaje Tornado
- **Declaración de variables**:
  - `var` permite declarar variables, con o sin asignación inicial.
  - `const` permite declarar constantes, siempre con asignación inicial.

- **Impresión de datos**:
  - `print` se utiliza para mostrar textos o valores en la salida estándar.

- **Entrada del usuario**:
  - `input` permite capturar valores ingresados por el usuario y asignarlos a una variable existente.

- **Operaciones aritméticas**:
  - Se soportan operaciones como suma (`+`), resta (`-`), multiplicación (`*`) y división (`/`).

- **Declaración de funciones**:
  - `function` permite definir funciones con bloques de código. Actualmente, las llamadas a funciones no están implementadas, pero se sientan las bases para futuras expansiones.

- **Estructuras de control** (no implementadas):
  - Palabras clave como `if`, `else`, `while`, `do` y `for` están reservadas para futuras implementaciones.

# Estructura Interna del Compilador

El compilador Tornado está dividido en varias fases, implementadas con **Flex** y **Bison**:

## 1. Análisis Léxico (Flex)

El lexer se encarga de procesar el código fuente y generar **tokens**, que son los elementos básicos del lenguaje.

**Tokens soportados**:

- **Palabras clave**: `var`, `const`, `function`, `print`, `input`.
- **Operadores**: `+`, `-`, `*`, `/`, `%`, `=`, `==`, `!=`, `<`, `>`, `<=`, `>=`, `&&`, `||`, `!`.
- **Identificadores**: Nombres de variables y funciones.
- **Literales**: Números (`123`), cadenas (`"Hola Mundo"`).

**Ejemplo de reglas en Flex**:
```c
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
```
## 2. Análisis Sintáctico (Bison)

El parser verifica que la secuencia de tokens cumpla con las reglas gramaticales y construye un *Árbol de Sintaxis Abstracta (AST).*
```c
variable_declaration:
    VAR IDENTIFIER ASSIGN expression SEMICOLON
        { assign_variable($2, $4); printf("Variable: %s = %d\n", $2, $4); }
  | CONST IDENTIFIER ASSIGN expression SEMICOLON
        { assign_variable($2, $4); symtable[symtable_count - 1].is_const = 1; }
  ;
```
## 3. Análisis Semántico
Se validan reglas como:
- Las variables deben declararse antes de usarse.
- Las constantes no pueden ser reasignadas.

## 4. Generación de Código Intermedio

El compilador produce un pseudocódigo que puede ser utilizado para la depuración y análisis.

## 5. Manejo de Errores

El compilador incluye manejo de errores léxicos, sintácticos y semánticos. Los mensajes son claros y ayudan al usuario a identificar y corregir problemas.
```
if (symtable[i].is_const) {
    fprintf(stderr, "Error: No se puede reasignar la constante '%s'.\n", name);
    exit(1);
}
```

### Ejemplo de Código en Tornado
```
// Declaración de variables con y sin asignación
var a = 5;
var b;
const c = 10;

// Impresión de mensajes
print "Inicio del programa:\n";
print "a = ";
print a;

// Entrada del usuario
input b;

// Operaciones aritméticas
var suma = a + b;
print "Suma de a y b = ";
print suma;

var producto = a * c;
print "Producto de a y c = ";
print producto;

// Declaración de una constante
const d = 50;
print "Constante d = ";
print d;

// Declaración de una función
function mostrar_valor_d() {
    print "Dentro de la función, d = ";
    print d;
}
```

## Conclusión

El compilador Tornado, implementado con **Flex** y **Bison**, es un proyecto educativo que demuestra cómo construir un lenguaje de programación básico y funcional.

Aunque todavía hay características en desarrollo, como las llamadas a funciones y estructuras de control, Tornado establece una base sólida para expandir sus capacidades. Este compilador es ideal para:
- Comprender los conceptos fundamentales de análisis léxico, sintáctico y semántico.
- Aprender los principios de diseño de lenguajes de programación.

