all:	test

test:	test.c
	clang -o test `pkg-config --cflags --libs sdl2` `pkg-config --cflags --libs cairo` test.c


clean:
	rm -f test test.o



