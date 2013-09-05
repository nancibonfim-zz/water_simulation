SRC=$(wildcard *.cpp)
OBJ=$(SRC:.cpp=.o)

CXXFLAGS=-g -O0 -Wall -Wextra
LDFLAGS=-lglut -lGL -lGLU -lm \
	 -lopencv_core -lopencv_highgui -lopencv_imgproc -lGLEW

EXECFILES = mar

all: $(EXECFILES)

mar: $(OBJ)

clean:
	rm -rf $(OBJ) $(EXECFILES)
