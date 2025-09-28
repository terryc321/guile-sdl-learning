


#OBJS specifies which files to compile as part of the project
OBJS = main.c

#OBJ_NAME specifies the name of our exectuable
OBJ_NAME = main

#This is the target that compiles our executable
# if i use gcc to compile files , program aborts SDL_Init with segfault
# if i use g++ , program runs fine ...
all : $(OBJS)
	g++ $(OBJS) -ggdb3 -Wall -Werror -lSDL2 -o $(OBJ_NAME)



