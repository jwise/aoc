unsigned long step(unsigned long r5) {
	unsigned long r4, r3;
	
	r4 = r5 | 0x10000;
	
	r5 = 0xEC01BB;
	while (1) {
		r5 = r5 + (r4 & 0xFF);
		r5 = r5 & 0xFFFFFF;
		r5 = r5 * 0x1016B;
		r5 = r5 & 0xFFFFFF;
		
		if (r4 < 256) break;

		r3 = 0;

		while ((r3 + 1) * 256 <= r4)
			r3++;

		r4 = r3;
	}
	
	return r5;
}

void main() {
	unsigned long r5_0 = 0, r5_1 = 0, r0 = 0;
	int steps = 0;
	do {
		r5_0 = step(r5_0);
		r5_1 = step(step(r5_1));
		printf("%x\n", r5_0);
		if (r5_0 == r5_1) printf("***\n");
		steps++;
	} while (r5_0 != r5_1 || steps < 64000);
	printf("steps %d\n", steps);
}