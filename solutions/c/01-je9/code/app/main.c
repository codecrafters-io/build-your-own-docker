#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>

// Usage: your_docker.sh run <image> <command> <arg1> <arg2> ...
int main(int argc, char *argv[]) {
	// Disable output buffering
	setbuf(stdout, NULL);
 	setbuf(stderr, NULL);

	char *command = argv[3];
	int child_pid = fork();
	if (child_pid == -1) {
	    printf("Error forking!");
	    return 1;
	}

	if (child_pid == 0) {
		   // Replace current program with calling program
	    execv(command, &argv[3]);
	} else {
		   // We're in parent
		   wait(NULL);
		   printf("Child terminated");
	}

	return 0;
}
