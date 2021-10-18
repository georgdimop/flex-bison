/* bison for C++320 language */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "symbol.h"


extern int yylex();
extern int yyparse();
extern int yylineno;
extern char *yytext;;
void yyerror(char *s);
extern char linebuf[];
extern int glob_scope;

%}


/************
*** Symbols
*************/


%precedence T_sizeop
%left T_mulop
%left T_addop
%left T_relop
%left T_equop
%precedence T_notop
%left T_andop
%left T_orop
%left T_comma



%union
{
	int ival;
	float fval;
	char* sval;
};

%token T_typedef 
%token <sval> T_char 
%token <ival> T_int 
%token <fval> T_float 
%token <fval> T_const 
%token T_class  T_private T_protected  T_public  T_this T_static T_union  T_continue  T_break  T_if  T_else T_while T_for T_return  T_cin  T_cout  T_main 
%token <sval> T_void 
%token <sval> T_id 
%token <ival> T_iconst 
%token <fval> T_fconst 
%token <sval> T_cconst 
%token <sval> T_orop 
%token <sval> T_andop 
%token <sval> T_equop 
%token <sval> T_relop 
%token <sval> T_addop 
%token <sval> T_mulop 
%token <sval> T_notop 
%token <sval> T_incdec 
%token <sval> T_sizeop 
%token <sval> T_string 
%token <sval> T_lparen 
%token <sval> T_rparen 
%token <sval> T_semi 
%token <sval> T_dot 
%token <sval> T_comma 
%token <sval> T_assign 
%token <sval> T_colon 
%token <sval> T_lbrack 
%token <sval> T_rbrack 
%token <sval> T_refer 
%token <sval> T_lbrace 
%token <sval> T_rbrace 
%token <sval> T_meth 
%token <sval> T_inp 
%token <sval> T_out 
%token <sval> T_comments 
%token <sval> T_lf 
%token <sval> T_ff 
%token <sval> T_ht 
%token <sval> T_cr 
%token <sval> T_bs 
%token <sval> T_vt 


%start program


/***********
****GRAMMAR
************/


%%


program : global_declarations main_function 
;

global_declarations : global_declarations global_declaration 
|%empty
;

global_declaration : typedef_declaration 
| const_declaration 
| class_declaration 
| union_declaration 
| global_var_declaration 
| func_declaration 
;


typedef_declaration :  T_typedef typename T_id  dims T_semi
;

typename : standard_type 
| T_id 
;

standard_type : T_char 
| T_int 
| T_float 
| T_void 
;

dims : dims dim 
|%empty
;

dim : T_lbrack T_iconst T_rbrack 
| T_lbrack T_rbrack 
;

const_declaration : T_const typename constdefs T_semi
;

constdefs : constdefs T_comma constdef
| constdef 
;

constdef : T_id dims T_assign init_value
;

init_value : expression 
| T_lbrace init_values T_rbrace 
| T_string 
;

expression :expression T_orop expression 
| expression T_andop expression 
| expression T_equop expression 
| expression T_relop expression 
| expression T_addop expression 
| expression T_mulop expression 
| T_notop expression 
| T_addop expression 
| T_sizeop expression 
| T_incdec variable 
| variable T_incdec 
| variable 
| variable T_lparen expression_list T_rparen
| constant 
| T_lparen general_expression T_rparen
| T_lparen standard_type T_rparen
;

variable : variable T_lbrack general_expression T_rbrack
| variable T_dot T_id
| decltype T_id
| T_this 
;

general_expression : general_expression T_comma general_expression
| assignment 
;

assignment : variable T_assign assignment
| variable T_assign T_string
| expression 
;

expression_list : general_expression 
|%empty
;

constant : T_cconst 
| T_iconst 
| T_fconst 
;

init_values : init_values T_comma init_value
| init_value 
;

class_declaration : T_class T_id class_body T_semi
;

class_body : parent T_lbrace members_methods T_rbrace
;

parent : T_colon T_id
|%empty
;

members_methods : members_methods access member_or_method
| access member_or_method
;

access : T_private T_colon
| T_protected T_colon
| T_public T_colon
|%empty
;

member_or_method : member 
| method 
;

member : var_declaration 
| anonymous_union 
;

var_declaration : typename variabledefs T_semi
;

variabledefs : variabledefs T_comma variabledef
| variabledef
;

variabledef : T_id dims
;

anonymous_union : T_union union_body T_semi
;

union_body : T_lbrace fields T_rbrace
;

fields : fields field
| field
;

field : var_declaration
;

method : short_func_declaration
;

short_func_declaration : short_par_func_header T_semi
| nopar_func_header T_semi
;

short_par_func_header : func_header_start T_lparen parameter_type_list T_rparen
;

func_header_start : typename T_id
;

parameter_type_list : parameter_type_list T_comma typename pass_dims
| typename pass_dims
;

pass_dims : dims
| T_refer
;

nopar_func_header : func_header_start T_lparen T_rparen
;

union_declaration : T_union union_body T_semi
;

global_var_declaration : typename init_variabledefs T_semi
;

init_variabledefs : init_variabledefs T_comma init_variabledef
| init_variabledef
;

init_variabledef : variabledef initializer
;

initializer : T_assign init_value
|%empty
;

func_declaration : short_func_declaration
| full_func_declaration
;

full_func_declaration : full_par_func_header T_lbrace decl_statements T_rbrace
| nopar_class_func_header T_lbrace decl_statements T_rbrace
| nopar_func_header T_lbrace decl_statements T_rbrace
;

full_par_func_header : class_func_header_start T_lparen parameter_list T_rparen
| func_header_start T_lparen parameter_list T_rparen
;

class_func_header_start : typename func_class T_id
;

func_class : T_id T_meth
;

parameter_list : parameter_list T_comma typename pass_variabledef
| typename pass_variabledef
;

pass_variabledef : variabledef
| T_refer T_id
;

nopar_class_func_header : class_func_header_start T_lparen T_rparen
;

decl_statements : declarations statements
| declarations
| statements
|%empty
;

declarations : declarations decltype typename variabledefs T_semi
| decltype typename variabledefs T_semi
;

decltype : T_static
|%empty 
;

statements : statements statement
| statement
;

statement : expression_statement
| if_statement
| while_statement
| for_statement
| return_statement
| io_statement
| comp_statement
| T_continue T_semi
| T_break T_semi
| T_semi
;

expression_statement : general_expression T_semi
;

if_statement : T_if T_lparen general_expression T_rparen statement {glob_scope=glob_scope + 1;} if_tail 
;

if_tail : T_else {glob_scope=glob_scope - 1;} statement 
|%empty
;

while_statement : T_while T_lparen general_expression T_rparen statement
;

for_statement : T_for T_lparen optexpr T_semi optexpr T_semi optexpr T_rparen statement
;

optexpr : general_expression
|%empty
;

return_statement : T_return optexpr T_semi
;

io_statement : T_cin T_inp in_list T_semi
| T_cout T_out out_list T_semi
;

in_list : in_list T_inp in_item
| in_item
;

in_item : variable
;

out_list : out_list T_out out_item
| out_item
;

out_item : general_expression
| T_string
;

comp_statement : T_lbrace decl_statements T_rbrace
;

main_function : main_header T_lbrace decl_statements T_rbrace
;

main_header : T_int T_main T_lparen T_rparen 
;

%%

 /***************
 ***FUCNTION
 ****************/
int yywrap() {return 1;}



int main(void) {
  

        		
	if(!yyparse()){
		printf("PARSE OK\n");
	}else{
		printf("PARSE failed\n");
	}

}

void yyerror(char *s) {
	printf("error  number %d  (%s) at line %d => %s\n",  yynerrs,s,yylineno,linebuf);
	if(yynerrs==5){
	printf("TOO MANY ERRORS, PARSE FAILED");
		exit(-1);}
}
