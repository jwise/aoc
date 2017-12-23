void main() {
	long long a = 1, b = 0, c = 0, f = 0, d = 0, e = 0, g = 0, h = 0, mulcnt = 0;
	
	b = 99;
	c = 99;
	
	if (a) {
		b *= 100; mulcnt++;
		b += 100000;
		c = b;
		c += 17000;
	}
	printf("b %d, c %d\n", b, c);
	
	do {
		if (b % 1 == 0) printf("b %d\n", b);
	
		f = 0;
		for (d = 2; d < b; d++) {
			if (b % d == 0) {
				f = 1;
				goto found;
			}
		}
		
		found:
		if (f)
			h++;
		
		if (b != c) b += 17;
		else break;
	} while(1);
	
	printf("mulcnt %d, h %d\n", mulcnt, h);
}
