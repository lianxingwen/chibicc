#define _GNU_SOURCE
#include "lexer.h"

Lexer* lexer_new(char *input) {
    Lexer *lexer = malloc(sizeof(Lexer));
    lexer->input = strdup(input);
    lexer->position = 0;
    lexer->line = 1;
    lexer->column = 1;
    lexer->length = strlen(input);
    return lexer;
}

void lexer_free(Lexer *lexer) {
    if (lexer) {
        free(lexer->input);
        free(lexer);
    }
}

void token_free(Token *token) {
    if (token && token->value) {
        free(token->value);
    }
}

char* token_type_to_string(TokenType type) {
    switch (type) {
        case TOKEN_EOF: return "EOF";
        case TOKEN_IDENTIFIER: return "IDENTIFIER";
        case TOKEN_STRING: return "STRING";
        case TOKEN_NUMBER: return "NUMBER";
        case TOKEN_ARROW: return "ARROW";
        case TOKEN_PIPE: return "PIPE";
        case TOKEN_SEMICOLON: return "SEMICOLON";
        case TOKEN_LPAREN: return "LPAREN";
        case TOKEN_RPAREN: return "RPAREN";
        case TOKEN_LBRACE: return "LBRACE";
        case TOKEN_RBRACE: return "RBRACE";
        case TOKEN_COLON: return "COLON";
        case TOKEN_EQUALS: return "EQUALS";
        case TOKEN_PLUS: return "PLUS";
        case TOKEN_STAR: return "STAR";
        case TOKEN_QUESTION: return "QUESTION";
        case TOKEN_NEWLINE: return "NEWLINE";
        case TOKEN_ERROR: return "ERROR";
        default: return "UNKNOWN";
    }
}

static void skip_whitespace(Lexer *lexer) {
    while (lexer->position < lexer->length) {
        char c = lexer->input[lexer->position];
        if (c == ' ' || c == '\t' || c == '\r') {
            lexer->position++;
            lexer->column++;
        } else if (c == '\n') {
            lexer->position++;
            lexer->line++;
            lexer->column = 1;
            return; // Don't skip newlines, they're significant
        } else {
            break;
        }
    }
}

static char* read_identifier(Lexer *lexer) {
    int start = lexer->position;
    while (lexer->position < lexer->length) {
        char c = lexer->input[lexer->position];
        if (isalnum(c) || c == '_') {
            lexer->position++;
            lexer->column++;
        } else {
            break;
        }
    }
    int length = lexer->position - start;
    char *value = malloc(length + 1);
    strncpy(value, lexer->input + start, length);
    value[length] = '\0';
    return value;
}

static char* read_string(Lexer *lexer) {
    lexer->position++; // Skip opening quote
    lexer->column++;
    int start = lexer->position;
    
    while (lexer->position < lexer->length) {
        char c = lexer->input[lexer->position];
        if (c == '"') {
            break;
        } else if (c == '\\' && lexer->position + 1 < lexer->length) {
            lexer->position += 2; // Skip escape sequence
            lexer->column += 2;
        } else {
            lexer->position++;
            lexer->column++;
        }
    }
    
    int length = lexer->position - start;
    char *value = malloc(length + 1);
    strncpy(value, lexer->input + start, length);
    value[length] = '\0';
    
    if (lexer->position < lexer->length) {
        lexer->position++; // Skip closing quote
        lexer->column++;
    }
    
    return value;
}

static char* read_number(Lexer *lexer) {
    int start = lexer->position;
    while (lexer->position < lexer->length) {
        char c = lexer->input[lexer->position];
        if (isdigit(c)) {
            lexer->position++;
            lexer->column++;
        } else {
            break;
        }
    }
    int length = lexer->position - start;
    char *value = malloc(length + 1);
    strncpy(value, lexer->input + start, length);
    value[length] = '\0';
    return value;
}

Token lexer_next_token(Lexer *lexer) {
    Token token;
    token.line = lexer->line;
    token.column = lexer->column;
    token.value = NULL;
    
    skip_whitespace(lexer);
    
    if (lexer->position >= lexer->length) {
        token.type = TOKEN_EOF;
        return token;
    }
    
    char c = lexer->input[lexer->position];
    
    switch (c) {
        case '\n':
            token.type = TOKEN_NEWLINE;
            lexer->position++;
            lexer->line++;
            lexer->column = 1;
            break;
            
        case '-':
            if (lexer->position + 1 < lexer->length && lexer->input[lexer->position + 1] == '>') {
                token.type = TOKEN_ARROW;
                lexer->position += 2;
                lexer->column += 2;
            } else {
                token.type = TOKEN_ERROR;
                lexer->position++;
                lexer->column++;
            }
            break;
            
        case '|':
            token.type = TOKEN_PIPE;
            lexer->position++;
            lexer->column++;
            break;
            
        case ';':
            token.type = TOKEN_SEMICOLON;
            lexer->position++;
            lexer->column++;
            break;
            
        case '(':
            token.type = TOKEN_LPAREN;
            lexer->position++;
            lexer->column++;
            break;
            
        case ')':
            token.type = TOKEN_RPAREN;
            lexer->position++;
            lexer->column++;
            break;
            
        case '{':
            token.type = TOKEN_LBRACE;
            lexer->position++;
            lexer->column++;
            break;
            
        case '}':
            token.type = TOKEN_RBRACE;
            lexer->position++;
            lexer->column++;
            break;
            
        case ':':
            token.type = TOKEN_COLON;
            lexer->position++;
            lexer->column++;
            break;
            
        case '=':
            token.type = TOKEN_EQUALS;
            lexer->position++;
            lexer->column++;
            break;
            
        case '+':
            token.type = TOKEN_PLUS;
            lexer->position++;
            lexer->column++;
            break;
            
        case '*':
            token.type = TOKEN_STAR;
            lexer->position++;
            lexer->column++;
            break;
            
        case '?':
            token.type = TOKEN_QUESTION;
            lexer->position++;
            lexer->column++;
            break;
            
        case '"':
            token.type = TOKEN_STRING;
            token.value = read_string(lexer);
            break;
            
        default:
            if (isalpha(c) || c == '_') {
                token.type = TOKEN_IDENTIFIER;
                token.value = read_identifier(lexer);
            } else if (isdigit(c)) {
                token.type = TOKEN_NUMBER;
                token.value = read_number(lexer);
            } else {
                token.type = TOKEN_ERROR;
                lexer->position++;
                lexer->column++;
            }
            break;
    }
    
    return token;
}