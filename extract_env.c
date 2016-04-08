#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

void usage(const char* prog_name)
{
    fprintf(stderr, "Usage:\n\t%s [-r] <envimage>\nParamenters\n\t-r\tthe image has redundant byte\n", prog_name);
}

char *basename(char *path)
{
	char *fname;

	fname = path + strlen(path) - 1;
	while (fname >= path) {
		if (*fname == '/') {
			fname++;
			break;
		}
		fname--;
	}
	return fname;
}

int main(int argc, char** argv)
{
    int redundant_bytes = 0;
    const int crc_bytes = 4;
    FILE *input = NULL;
    char *input_name = NULL;

    if (argc == 3 && 0 == strcmp("-r", argv[1])) {
        redundant_bytes = 1;
        input_name = argv[2];
    } else if (argc != 2) {
        usage(basename(argv[0]));
        return 1;
    } else {
        input_name = argv[1];
    }

    if (NULL == (input = fopen(input_name, "r"))) {
        fprintf(stderr, "Failed to open image file %s\n", input_name);
        return 1;
    }

    for (int i = 0; i < crc_bytes + redundant_bytes; ++i) {
        if (EOF == fgetc(input)) {
            fprintf(stderr, "File is too short\n");
            return 1;
        }
    }

    char c;
    int last_is_null = 0;
    while (EOF != (c = fgetc(input))) {
        if (c == 0) {
            if (!last_is_null) {
                last_is_null = 1;
                putchar('\n');
            }
        } else {
            last_is_null = 0;
            putchar(c);
        }

    }
    if (!feof(input)) {
        fprintf(stderr, "Failed to read image file\n");
        return 1;
    }

    fclose(input);

    return 0;
}
