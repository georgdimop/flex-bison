#ifndef _symbol_h

struct List
{
	char *id;
	int i;
	struct List *nxt;
};

typedef struct List list;

list *head;

list *initialize();

void add(char *id, int i);

void clear();

list *find(char *id, int i);

void view();

#endif
