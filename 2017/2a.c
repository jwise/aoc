#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFSZ 4096

void main() {
	int i;
	int s = 0;
	char buf[BUFSZ];
	int cksm = 0;
	
	while (fgets(buf, BUFSZ, stdin)) {
		int big = -1;
		int small = 0x7FFFFFFF;
		char *sp = buf;
		
		while (*sp) {
			int num = 0;
			
			while (isdigit(*sp)) {
				num *= 10;
				num += *sp - '0';
				sp++;
			}
			
			if (num > big) big = num;
			if (num < small) small = num;
			
			while (*sp && !isdigit(*sp))
				sp++;
		}
		
		printf("big: %d, small: %d, del: %d\n", big, small, big - small);
		cksm += big - small;
	}
	
	printf("cksm %d\n", cksm);
}
