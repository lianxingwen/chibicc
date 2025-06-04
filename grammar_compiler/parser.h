#ifndef PARSER_H
#define PARSER_H

#include "lexer.h"
#include "ast.h"

typedef struct {
    Lexer *lexer;
    Token current_token;
    int has_error;
    char *error_message;
} Parser;

Parser* parser_new(Lexer *lexer);
void parser_free(Parser *parser);
ASTNode* parser_parse_grammar(Parser *parser);
void parser_error(Parser *parser, char *message);

#endif