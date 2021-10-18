 /* scanner for C++320 language */

%{
 /* need this for the call to strtol below */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "symbol.h"
#include <stdio.h>
#include "y.tab.h"  // to get the token types that we return

int glob_scope=1;
int lineno=0;
char linebuf[500];
char strbuf[1000];
extern list *head;
void yyerror(char *s);
%}


/*%option yylineno*/
%x comments
%x string

DIGIT    [0-9]
ID       ([_]*[a-zA-Z]+[a-zA-Z0-9]*([_][a-zA-Z0-9]+)*)

%%
    /**************************
    ****** LEKSEIS-KLEIDIA
    **************************/

TYPEDEF|typedef { lineno=0;return (T_typedef); }
CHAR|char { lineno=0;return (T_char); }
INT|int { lineno=0;return (T_int); }
FLOAT|float { lineno=0;return (T_float); }
const|CONST { lineno=0;return (T_const); }
class|CLASS { lineno=0;return (T_class); }
PRIVATE|private { lineno=0;return (T_private); }
PROTECTED|protected { lineno=0;return (T_protected); }
PUBLIC|public { lineno=0;return (T_public); }
THIS|this { lineno=0;return (T_this); }
VOID|void { lineno=0;return (T_void); } 
STATIC|static { lineno=0;return (T_static); }
UNION|union { lineno=0;return (T_union); }
CONTINUE|continue { lineno=0;return (T_continue); }
BREAK|break { lineno=0;return (T_break); }
IF|if { lineno=0;return (T_if); }
ELSE|else { lineno=0;return (T_else); }
WHILE|while { lineno=0;return (T_while); }
FOR|for { lineno=0;return (T_for); }
RETURN|return { lineno=0;return (T_return); }
CIN|cin { lineno=0;return (T_cin); }
COUT|cout { lineno=0;return (T_cout); }
MAIN|main { lineno=0;return (T_main); }



    /**************************
    ****** SXOLIA
    **************************/

"/*" { BEGIN(comments); }
<comments>{
([^*]+|\*+[^*/])*\* {}
"/" {BEGIN(INITIAL);lineno=0;}
}
"\\" { BEGIN(comments); }
<comments>{
[^"\n|]* { }
\n {BEGIN(INITIAL);lineno=0;}
}

	
    /*********************
    *** SIZEOF
    ****************/
sizeof|SIZEOF            { lineno=0;return (T_sizeop); }


            
    /**************************
    ****** ANAGNWRISTIKA(ID)
    **************************/


{ID}        {yylval.sval=strdup(yytext);lineno=0;add(yylval.sval,glob_scope);view();return (T_id);}


    /**************************
    **** APLES STATHERES
    **************************/

    

     /****************************************
    *** MH PROSIMASMENES PRAGMATIKES(FCONST)
    ****************************************/

({DIGIT}*"."{DIGIT}+[E]?("+"|"-")?{DIGIT}+)|([1-9]{DIGIT}*[E]("+"|"-")?{DIGIT}+) { yylval.fval=atof(yytext);lineno=0;return (T_fconst); }

("0X"[1-9]{DIGIT}*"."{DIGIT}+)|("0X"[1-9]+([ABCDEF]*[0-9]*)*"."[0-9]+([0-9]*[ABCDEF]*)*)|("0x"[1-9]+([ABCDEF]*[0-9]*)*"."[0-9]+([0-9]*[ABCDEF]*)*)|("0x"[1-9]{DIGIT}*"."{DIGIT}+)|("0X"[ABCDEF]+([ABCDEF]*[0-9]*)*"."[0-9]+([0-9]*[ABCDEF]*)*)|("0x"[ABCDEF]+([ABCDEF]*[0-9]*)*"."[0-9]+([0-9]*[ABCDEF]*)*) {	                char c;
									int akeraio_meros=1;
									int akeraia_timi=0;
									float dekadikh_timi=0;
									int i=0;
									int k=0;
									float j;
									int g=0;
									for(i=2;i<yyleng;i++){ 	//i=2 giati to yytext deixnei ston prwto xarakthra(0) kai emeis theloume to 3o
										c=*(yytext+i);
										if(c!='.' && akeraio_meros==1){
											if(isdigit(c)){akeraia_timi=akeraia_timi*16+(c-'0');}
											else{
												switch(c){
	
													case 'A':
														akeraia_timi=(akeraia_timi*16)+10;
													break;
													case 'B':
														akeraia_timi=(akeraia_timi*16)+11;
													break;
													case 'C':
														akeraia_timi=(akeraia_timi*16)+12;
													break;
													case 'D':
														akeraia_timi=(akeraia_timi*16)+13;
													break;
													case 'E':
														akeraia_timi=(akeraia_timi*16)+14;
													break;
													case 'F':
														akeraia_timi=(akeraia_timi*16)+15;
													break;
												}
											}
										}
										else if(c=='.'){
											akeraio_meros=0;
											k=1;
										}
										else{
											if(isdigit(c)){	
												j=1;
												for(g=0;g<k;g++){
													j=j*16;
												}
												dekadikh_timi=dekadikh_timi + ((c-'0')/j);
												k++;
											}
											else
											{		
												j=1;
												for(g=0;g<k;g++){
													j=j*16;
												}
													
												switch(c)//giati to yytext deixnei sto prwto char poy ekane match ston input buffer kai  emeis theloume to 3o
												{
													case 'A':
														dekadikh_timi=dekadikh_timi + ((10)/j);k++;
													break;
													case 'B':
														dekadikh_timi=dekadikh_timi + ((11)/j);k++;
													break;
													case 'C':
														dekadikh_timi=dekadikh_timi + ((12)/j);k++;
													break;
													case 'D':
														dekadikh_timi=dekadikh_timi + ((13)/j);k++;
													break;
													case 'E':
														dekadikh_timi=dekadikh_timi + ((14)/j);k++;
													break;
													case 'F':
														dekadikh_timi=dekadikh_timi + ((15)/j);k++;
													break;
												}
											}
										}
									}
									yylval.fval=akeraia_timi+dekadikh_timi;lineno=0;return (T_fconst);
								  }


("0B"[1][01]*"."[01]+)|("0b"[1][01]*"."[01]+)       {	                                int akeraio_meros=1;
											int akeraia_timi=0;
											float dekadikh_timi=0;
											int i=0;
											int k=0;
											float j;
											int g=0;
											for(i=2;i<yyleng;i++)
											{
											
												char c = *(yytext+i);
												if(c!='.' && akeraio_meros==1){
													akeraia_timi=akeraia_timi*2+(c-'0');
												}
												else if(c=='.'){
													akeraio_meros=0;
													k=1;
												}
												else{	j=1;
													for(g=0;g<k;g++){
														j=j*2;
													}
													dekadikh_timi=dekadikh_timi + ((c-'0')/j);
													k++;		
												}
											}
											yylval.fval=akeraia_timi+dekadikh_timi;
											lineno=0;return (T_fconst);
										 }



    /**************************************
    **** MH PROSIMASMENES AKERAIES(ICONST)
    **************************************/



            
[1-9]{DIGIT}*   { yylval.ival=atoi(yytext);lineno=0;return (T_iconst); }

("0X"[1-9]{DIGIT}*)|("0X"[1-9]+([ABCDEF]*[0-9]*)*)|("0X"[ABCDEF]+([ABCDEF]*[0-9]*)*)|("0x"[1-9]{DIGIT}*)|("0x"[1-9]+([ABCDEF]*[0-9]*)*)|("0x"[ABCDEF]+([ABCDEF]*[0-9]*)*) 	{                               int val=0;						
									int i=0;
									for( i=2;i<yyleng;i++){ 
										char temp = *(yytext+i);
						 				if(isdigit(temp)){
							 				val=val*16+(temp-'0');
										 }
										else{
								 			switch(temp)//i=2 giati to yytext deixnei ston prwto xarakthra(0) tou string  kai emeis theloume to 3o
								 				{
								 					case 'A':
									 					val=(val*16)+10;
									 				break;
								 					case 'B':
														val=(val*16)+11;
									 				break;
								 					case 'C':
									 					val=(val*16)+12;
									 				break;
								 					case 'D':
									 					val=(val*16)+13;
									 				break;
													case 'E':
									 					val=(val*16)+14;
									 				break;
								 					case 'F':
									 					val=(val*16)+15;
									 				break;
							 					}
										 }
									 }
							 		yylval.ival=val; 	
									lineno=0;return (T_iconst);
								}


"0B"[1][01]*|"0b"[1][01]*                               {	int val=0;
								int i=0;
							 	for( i=2;i<yyleng;i++){
									char temp = *(yytext+i);
						 			val=val*2+(temp-'0');
						 		}
					 		 yylval.ival=val;
							 lineno=0;return(T_iconst);
						        }

[0]         { yylval.ival=atoi(yytext);lineno=0;return (T_iconst); }


    /**************************
    ** CCONST !
    **************************/

"\'"[ -~]"\'"|"\'""\\"[nftrbv]"\'"		{   yylval.sval=strdup(yytext);
                                                    char temp = *(yytext+2);
                                                    if(temp=='n'){
                                                            lineno=0;return (T_lf); 
                                                                    }
                                                    else if (temp=='f') {
                                                            lineno=0;return (T_ff); 
                                                                    }
                                                    else if (temp=='t') {
                                                            lineno=0;return (T_ht); 
                                                                    }
                                                    else if (temp=='r') {
                                                            lineno=0;return (T_cr); 
                                                                    }
                                                    else if (temp=='b') {
                                                            lineno=0;return (T_bs); 
                                                                    }
                                                    else if (temp=='v') {
                                                            lineno=0;return (T_vt); 
                                                                    }

                                                    else	{			 			
                                                        lineno=0;return (T_cconst); }
                                                 }


    /**************************
    ******* TELESTES
    **************************/

"||"      { lineno=0;return (T_orop); }

"&&"       { lineno=0;return (T_andop); }

"=="|"!="   { lineno=0;yylval.sval=strdup(yytext);return (T_equop); }

">"|">="|"<"|"<="   { lineno=0;yylval.sval=strdup(yytext);return (T_relop); }

"+"|"-"             { lineno=0;yylval.sval=strdup(yytext);return (T_addop); }

"*"|"/"|"%"         { lineno=0;yylval.sval=strdup(yytext);return (T_mulop); }

"!"                 { lineno=0;return (T_notop); }

"++"|"--"           { lineno=0;yylval.sval=strdup(yytext);return (T_incdec); }


    /**************************
    **** ORMATHOI XARAKTIRWN(STRING)
    **************************/


"\"" {strbuf[0]='\0';BEGIN(string);}
<string>{
[ -!#-Z_-~]|"["|"]"|"^"   {strcat(strbuf,yytext);}
"\\""\n" { }
"\\".   {strcat(strbuf,yytext);;}
"\""	{yylval.sval=strdup(strbuf);BEGIN(INITIAL);lineno=0;return (T_string);}

"<EOF>" {printf("ERROR illegally terminated string");exit(1);}
}
    /**************************
    **** ALLES LEKTIKES MONADES
    **************************/


"(" { lineno=0;return (T_lparen); }
")" { lineno=0;return (T_rparen); }
";" { lineno=0;return (T_semi); }
"." { lineno=0;return (T_dot); }
"," { lineno=0;return (T_comma); }
"=" { lineno=0;return (T_assign); }
":" { lineno=0;return (T_colon); }
"[" { lineno=0;return (T_lbrack); }
"]" { lineno=0;return (T_rbrack); }
"&" { lineno=0;return (T_refer); }
"{" { lineno=0;return (T_lbrace); }
"}" { lineno=0;return (T_rbrace); }
"::" { lineno=0;return (T_meth); }
">>" { lineno=0;return (T_inp); }
"<<" { lineno=0;return (T_out); }
"<EOF>" {return 0;}
			

 [ \t\n]+          /* eat up whitespace */

.                                                       {	lineno++;
								printf("In line \"%s\" with number %d => Invalid argument: %s\n",linebuf, yylineno, yytext);					
                                                                exit(1);	
                                                        }
                                                

%%
