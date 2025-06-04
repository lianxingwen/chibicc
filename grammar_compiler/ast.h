#ifndef AST_H
#define AST_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    AST_GRAMMAR,
    AST_RULE,
    AST_PRODUCTION,
    AST_SEQUENCE,
    AST_CHOICE,
    AST_TERMINAL,
    AST_NONTERMINAL,
    AST_OPTIONAL,
    AST_REPETITION,
    AST_PLUS_REPETITION,
    AST_ACTION
} ASTNodeType;

typedef struct ASTNode {
    ASTNodeType type;
    char *value;
    struct ASTNode **children;
    int child_count;
    int child_capacity;
} ASTNode;

ASTNode* ast_node_new(ASTNodeType type, char *value);
void ast_node_free(ASTNode *node);
void ast_node_add_child(ASTNode *parent, ASTNode *child);
void ast_node_print(ASTNode *node, int indent);
char* ast_node_type_to_string(ASTNodeType type);

#endif