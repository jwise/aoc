#define BUFSZ 400 * 1024 * 1024
unsigned char buf[BUFSZ] = {0};
void main() {
	buf[0] = 3;
	buf[1] = 7;
	unsigned long bufpos = 2;
	unsigned long elves[2] = { 0,1 };
	unsigned long iter = 0;
	unsigned char compar[] = { 5,4,0,3,9,1 };
	
	while(1) {
		unsigned char tot = buf[elves[0]] + buf[elves[1]];
		
		if (tot == 0) {
			buf[bufpos] = 0;
			bufpos++;
		} else {
			unsigned char lilbuf[4];
			int lilbufpos = 0;
			while (tot > 0) {
				lilbuf[lilbufpos] = tot % 10;
				lilbufpos++;
				tot /= 10;
			}
			for (int i = lilbufpos-1; i >= 0; i--) {
				buf[bufpos] = lilbuf[i];
				bufpos++;
			}
		}
		
		for (int i = 0; i < 2; i++) {
			unsigned long pos = elves[i];
			pos = pos + 1 + buf[elves[i]];
			elves[i] = pos % bufpos;
		}
		
		int good = 1;
		for (int i = 0; i < sizeof(compar); i++) {
			if (buf[bufpos-sizeof(compar)-2+i] != compar[i]) {good = 0; break;}
		}
		if (good) {
			printf("%d\n", bufpos-sizeof(compar)-2);
			exit(1);
		}
	}
	
	for (int i = bufpos-10; i < bufpos; i++)
		printf("%d", buf[i]);
	printf("\n");
}