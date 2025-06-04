#ifndef COMPILER_H
#define COMPILER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// 为了兼容性，定义strdup
char* my_strdup(const char* s);

// 词法分析器
typedef enum {
    TOKEN_NUMBER,
    TOKEN_IDENTIFIER,
    TOKEN_ASSIGN,     // =
    TOKEN_PLUS,       // +
    TOKEN_MINUS,      // -
    TOKEN_MULTIPLY,   // *
    TOKEN_DIVIDE,     // /
    TOKEN_LPAREN,     // (
    TOKEN_RPAREN,     // )
    TOKEN_SEMICOLON,  // ;
    TOKEN_PRINT,      // print
    TOKEN_IF,         // if
    TOKEN_ELSE,       // else
    TOKEN_WHILE,      // while
    TOKEN_LBRACE,     // {
    TOKEN_RBRACE,     // }
    TOKEN_EQ,         // ==
    TOKEN_LT,         // <
    TOKEN_GT,         // >
    TOKEN_EOF,
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
} Lexer;

// 抽象语法树
typedef enum {
    AST_NUMBER,
    AST_VARIABLE,
    AST_BINARY_OP,
    AST_ASSIGNMENT,
    AST_PRINT,
    AST_IF,
    AST_WHILE,
    AST_BLOCK,
    AST_PROGRAM
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;
    union {
        int number;
        char *variable;
        struct {
            char op;
            struct ASTNode *left;
            struct ASTNode *right;
        } binary;
        struct {
            char *var_name;
            struct ASTNode *value;
        } assignment;
        struct {
            struct ASTNode *expression;
        } print;
        struct {
            struct ASTNode *condition;
            struct ASTNode *then_stmt;
            struct ASTNode *else_stmt;
        } if_stmt;
        struct {
            struct ASTNode *condition;
            struct ASTNode *body;
        } while_stmt;
        struct {
            struct ASTNode **statements;
            int count;
            int capacity;
        } block;
    } data;
} ASTNode;

// 解析器
typedef struct {
    Token *tokens;
    int position;
    int count;
} Parser;

// 变量存储
typedef struct {
    char *name;
    int value;
} Variable;

typedef struct {
    Variable *vars;
    int count;
    int capacity;
} Environment;

// 函数声明
Lexer* lexer_new(char *input);
void lexer_free(Lexer *lexer);
Token lexer_next_token(Lexer *lexer);

Parser* parser_new(Token *tokens, int count);
void parser_free(Parser *parser);
ASTNode* parser_parse(Parser *parser);

ASTNode* ast_node_new(ASTNodeType type);
void ast_node_free(ASTNode *node);

Environment* env_new();
void env_free(Environment *env);
void env_set(Environment *env, char *name, int value);
int env_get(Environment *env, char *name);

int interpret(ASTNode *node, Environment *env);
void compile_to_c(ASTNode *node, FILE *output);

#endif