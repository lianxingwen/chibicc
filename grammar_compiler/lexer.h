#ifndef LEXER_H
#define LEXER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

typedef enum {
    TOKEN_EOF,
    TOKEN_IDENTIFIER,
    TOKEN_STRING,
    TOKEN_NUMBER,
    TOKEN_ARROW,        // ->
    TOKEN_PIPE,         // |
    TOKEN_SEMICOLON,    // ;
    TOKEN_LPAREN,       // (
    TOKEN_RPAREN,       // )
    TOKEN_LBRACE,       // {
    TOKEN_RBRACE,       // }
    TOKEN_COLON,        // :
    TOKEN_EQUALS,       // =
    TOKEN_PLUS,         // +
    TOKEN_STAR,         // *
    TOKEN_QUESTION,     // ?
    TOKEN_NEWLINE,
    TOKEN_ERROR
} TokenType;

typedef struct {
    TokenType type;
    char *value;
    int line;
    int column;
} Token;

typedef struct {
    char *input;
    int position;
    int line;
    int column;
    int length;
} Lexer;

Lexer* lexer_new(char *input);
void lexer_free(Lexer *lexer);
Token lexer_next_token(Lexer *lexer);
void token_free(Token *token);
char* token_type_to_string(TokenType type);

#endif