CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -g
TARGET = grammar_compiler
SOURCES = main.c lexer.c parser.c ast.c codegen.c
OBJECTS = $(SOURCES:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET) parser.c

test: $(TARGET)
	./$(TARGET) examples/arithmetic.grammar

.PHONY: all clean test