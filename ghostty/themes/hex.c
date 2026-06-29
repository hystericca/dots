// how does one get into this type of shit?

#include <stdio.h>

int main() {
	printf("how you develop later in life");
	int max = 2;
	int* pMax = &max;
	for (int i = 0; i < *pMax; i++) {
		printf("hello");
	}
}
