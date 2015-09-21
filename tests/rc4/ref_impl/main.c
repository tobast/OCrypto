#include "arcfour.h"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char** argv) {
	if(argc < 4) {
		fprintf(stderr, "ERROR: Missing argument. Usage:\n%s [keyfile] [datafile] [outfile]", argv[0]);
		exit(1);
	}

	FILE* keyHandle = fopen(argv[1], "r");
	FILE* dataHandle = fopen(argv[2], "r");
	FILE* outHandle = fopen(argv[3], "w");

	BYTE key[256];
	BYTE xorByte;
	int keylen = 0;
	int curCh = fgetc(keyHandle);
	while(curCh != EOF) {
		key[keylen] = curCh;
		keylen += 1;
		if(keylen >= 256)
			break;

		curCh = fgetc(keyHandle);
	}
	fclose(keyHandle);

	BYTE state[256];
	arcfour_key_setup(state, key, keylen);
	int rc4i=0, rc4j=0;

	// Discard 1536 bytes
	int disc;
	for(disc=0; disc < 1536; disc++)
		arcfour_generate_stream(&rc4i, &rc4j, state, &xorByte, 1);
	
	curCh = fgetc(dataHandle);
	while(curCh != EOF) {
		arcfour_generate_stream(&rc4i, &rc4j, state, &xorByte, 1);
		fputc(xorByte ^ curCh, outHandle);
		
		curCh = fgetc(dataHandle);
	}
	fclose(outHandle);
	fclose(dataHandle);

	return 0;
}

