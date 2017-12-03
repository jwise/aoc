#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFSZ 4096

void main() {
	int i;
	int s = 0;
	char buf[BUFSZ];
	
	if (!fgets(buf, BUFSZ, stdin)) abort();
	
	for (int i = 0; isdigit(buf[i]); i++) {
		char c2 = buf[i+1];
		if (!isdigit(c2))
			c2 = buf[0];
		
		if (buf[i] == c2)
			s += buf[i] - '0';
	}
	printf("%d\n", s);
}
