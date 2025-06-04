#include "compiler.h"

static char* my_strdup_local(const char* s) {
    if (!s) return NULL;
    size_t len = strlen(s) + 1;
    char* copy = malloc(len);
    if (copy) memcpy(copy, s, len);
    return copy;
}

Lexer* lexer_new(char *input) {
    Lexer *lexer = malloc(sizeof(Lexer));
    lexer->input = my_strdup_local(input);
    lexer->position = 0;
    lexer->line = 1;
    lexer->column = 1;
    return lexer;
}

void lexer_free(Lexer *lexer) {
    if (lexer) {
        free(lexer->input);
        free(lexer);
    }
}

static void skip_whitespace(Lexer *lexer) {
    while (lexer->position < strlen(lexer->input)) {
        char c = lexer->input[lexer->position];
        
        // 跳过空白字符
        if (isspace(c)) {
            if (c == '\n') {
                lexer->line++;
                lexer->column = 1;
            } else {
                lexer->column++;
            }
            lexer->position++;
        }
        // 跳过单行注释
        else if (c == '/' && lexer->position + 1 < strlen(lexer->input) && 
                 lexer->input[lexer->position + 1] == '/') {
            // 跳过到行尾
            while (lexer->position < strlen(lexer->input) && 
                   lexer->input[lexer->position] != '\n') {
                lexer->position++;
            }
        }
        else {
            break;
        }
    }
}

static char peek_char(Lexer *lexer) {
    if (lexer->position >= strlen(lexer->input)) {
        return '\0';
    }
    return lexer->input[lexer->position];
}

static char next_char(Lexer *lexer) {
    if (lexer->position >= strlen(lexer->input)) {
        return '\0';
    }
    char c = lexer->input[lexer->position];
    lexer->position++;
    lexer->column++;
    return c;
}

static Token make_token(TokenType type, char *value, int line, int column) {
    Token token;
    token.type = type;
    token.value = value ? my_strdup_local(value) : NULL;
    token.line = line;
    token.column = column;
    return token;
}

static Token read_number(Lexer *lexer) {
    int start = lexer->position;
    int line = lexer->line;
    int column = lexer->column;
    
    while (isdigit(peek_char(lexer))) {
        next_char(lexer);
    }
    
    int length = lexer->position - start;
    char *value = malloc(length + 1);
    strncpy(value, lexer->input + start, length);
    value[length] = '\0';
    
    Token token = make_token(TOKEN_NUMBER, value, line, column);
    free(value);
    return token;
}

static Token read_identifier(Lexer *lexer) {
    int start = lexer->position;
    int line = lexer->line;
    int column = lexer->column;
    
    while (isalnum(peek_char(lexer)) || peek_char(lexer) == '_') {
        next_char(lexer);
    }
    
    int length = lexer->position - start;
    char *value = malloc(length + 1);
    strncpy(value, lexer->input + start, length);
    value[length] = '\0';
    
    TokenType type = TOKEN_IDENTIFIER;
    if (strcmp(value, "print") == 0) type = TOKEN_PRINT;
    else if (strcmp(value, "if") == 0) type = TOKEN_IF;
    else if (strcmp(value, "else") == 0) type = TOKEN_ELSE;
    else if (strcmp(value, "while") == 0) type = TOKEN_WHILE;
    
    Token token = make_token(type, value, line, column);
    free(value);
    return token;
}

Token lexer_next_token(Lexer *lexer) {
    skip_whitespace(lexer);
    
    if (lexer->position >= strlen(lexer->input)) {
        return make_token(TOKEN_EOF, NULL, lexer->line, lexer->column);
    }
    
    char c = peek_char(lexer);
    int line = lexer->line;
    int column = lexer->column;
    
    if (isdigit(c)) {
        return read_number(lexer);
    }
    
    if (isalpha(c) || c == '_') {
        return read_identifier(lexer);
    }
    
    next_char(lexer);
    
    switch (c) {
        case '=':
            if (peek_char(lexer) == '=') {
                next_char(lexer);
                return make_token(TOKEN_EQ, "==", line, column);
            }
            return make_token(TOKEN_ASSIGN, "=", line, column);
        case '+':
            return make_token(TOKEN_PLUS, "+", line, column);
        case '-':
            return make_token(TOKEN_MINUS, "-", line, column);
        case '*':
            return make_token(TOKEN_MULTIPLY, "*", line, column);
        case '/':
            return make_token(TOKEN_DIVIDE, "/", line, column);
        case '(':
            return make_token(TOKEN_LPAREN, "(", line, column);
        case ')':
            return make_token(TOKEN_RPAREN, ")", line, column);
        case ';':
            return make_token(TOKEN_SEMICOLON, ";", line, column);
        case '{':
            return make_token(TOKEN_LBRACE, "{", line, column);
        case '}':
            return make_token(TOKEN_RBRACE, "}", line, column);
        case '<':
            return make_token(TOKEN_LT, "<", line, column);
        case '>':
            return make_token(TOKEN_GT, ">", line, column);
        default:
            return make_token(TOKEN_ERROR, NULL, line, column);
    }
}