#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol.h"

list *initialize(){
	
	head = NULL;
	return head;
}


void add(char *id, int i){
	
	list *new;
	
	new = (list *)malloc(sizeof(list));
	if(new==NULL){
		
	  printf("Memory error\n");
	  exit(1);
	}
	
	new->id = malloc((strlen(id)+1)*sizeof(char));
	strcpy(new->id, id);
	new->i = i;
	new->nxt = head;
	head = new;
	return;
}

list *find(char *id, int i){
	
	list *s;
	s = head;
	while(s != NULL)
	{
	  if(strcmp(id, s->id)==0 && s->i==i){
	  	  
	    return s;
	  }
	  
	  s = s->nxt;
	  
	}
	
	printf("Not found\n");
	return NULL;
}



void clear(){
	
	list *d;
	
	while(head != NULL)
	{
	  d = head->nxt;
	  free(head);
	  head = d;
	}
	
	return;
}
	
	
void view(){
	
	list *v;
	v = head;
	
	while(v != NULL){
		
		printf("ID: %s, count: %d\n", v->id, v->i);
		v = v->nxt;
	}
  
  return;
}
  
