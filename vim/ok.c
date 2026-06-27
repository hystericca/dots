/**
 * github_test.c
 * This comment block should be low-opacity, faded gray (#8b949e).
 */

#include <stdio.h>	// '#include' is RED (#ff7b72). '<stdio.h>' is LIGHT BLUE (#a5d6ff).
#define MAX_BUFFER 1024 // '#define' and 'MAX_BUFFER' are RED (#ff7b72). '1024' is BLUE (#79c0ff).

// Primitive structures, macros, and storage indicators should match perfectly.
typedef struct {
	int    id;	 // 'int' must be RED (#ff7b72). 'id' is FOREGROUND text (#c9d1d9).
	char*  name;	 // 'char' must be RED (#ff7b72).
	double velocity; // 'double' must be RED (#ff7b72).
} Entity;		 // Custom types map directly to PURPLE (#d2a8ff).

static const int GLOBAL_FLAG = 1; // 'static', 'const', 'int' are all RED (#ff7b72).

/**
 * Process incoming system buffer coordinates
 */
Entity* initialize_entity(int entity_id, const char* initial_name) {
	// 'initialize_entity' call signature maps directly to PURPLE (#d2a8ff).
	// Primitives in arguments ('int', 'char') stay RED (#ff7b72).

	if (entity_id < 0 ||
	    entity_id == MAX_BUFFER) { // 'if' is RED (#ff7b72). Operators are FOREGROUND.
		return NULL;	       // 'return' is RED (#ff7b72). 'NULL' is BLUE (#79c0ff).
	}

	// Standard local assignments
	int  counter = 0; // '0' is BLUE (#79c0ff).
	char standard_string[] =
	    "GitHub Dark Default Test"; // String content is LIGHT BLUE (#a5d6ff).

	// Formatting escape vectors inside a literal sequence
	printf("Initializing payload: %s\n", standard_string);
	// 'printf' is a function execution: BLUE (#79c0ff) or PURPLE (#d2a8ff).
	// '%s\n' inside the literal string stays part of the string layout or lights up ORANGE
	// (#ffa657).

	for (int i = 0; i < 10; i++) { // 'for' loop controller is RED (#ff7b72).
		counter += i;
	}

	return NULL;
}
