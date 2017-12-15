#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#define AMUL 16807
#define BMUL 48271

void main(int argc, char **argv)
{
	uint64_t ast = strtoull(argv[1], NULL, 0);
	uint64_t bst = strtoull(argv[2], NULL, 0);
	
	int i;
	int matches = 0;
	for (i = 0; i < 5000000; i++) {
		do
			ast = (ast * AMUL) % 0x7FFFFFFF;
		while (ast & 3);
		do
			bst = (bst * BMUL) % 0x7FFFFFFF;
		while (bst & 7);
		if ((ast & 0xFFFF) == (bst & 0xFFFF))
			matches++;
	}
	printf("%d\n", matches);
}