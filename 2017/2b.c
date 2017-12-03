#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>

#define BUFSZ 4096
#define NUMS 128

void main() {
	char buf[BUFSZ];
	int cksm = 0;
	
	while (fgets(buf, BUFSZ, stdin)) {
		int nums[NUMS];
		int nnums = 0;
		int i, j;

		char *sp = buf;
		
		while (*sp) {
			int num = 0;
			
			while (isdigit(*sp)) {
				num *= 10;
				num += *sp - '0';
				sp++;
			}
			
			nums[nnums] = num;
			nnums++;
			if (nnums >= NUMS) abort();
			
			while (*sp && !isdigit(*sp))
				sp++;
		}
		
		int div = -1;
		for (i = 0; i < nnums; i++)
			for (j = 0; j < nnums; j++)
				if (i != j && (nums[i] % nums[j]) == 0) {
					div = nums[i] / nums[j];
				}

		if (div == -1) {
			printf("no, it wasn't\n");
			abort();
		}
		
		printf("div: %d\n", div);
		cksm += div;
	}
	
	printf("cksm %d\n", cksm);
}
