#define _GNU_SOURCE
#include "ast.h"

ASTNode* ast_node_new(ASTNodeType type, char *value) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = type;
    node->value = value ? strdup(value) : NULL;
    node->children = NULL;
    node->child_count = 0;
    node->child_capacity = 0;
    return node;
}

void ast_node_free(ASTNode *node) {
    if (!node) return;
    
    for (int i = 0; i < node->child_count; i++) {
        ast_node_free(node->children[i]);
    }
    
    free(node->children);
    free(node->value);
    free(node);
}

void ast_node_add_child(ASTNode *parent, ASTNode *child) {
    if (parent->child_count >= parent->child_capacity) {
        parent->child_capacity = parent->child_capacity == 0 ? 4 : parent->child_capacity * 2;
        parent->children = realloc(parent->children, parent->child_capacity * sizeof(ASTNode*));
    }
    parent->children[parent->child_count++] = child;
}

char* ast_node_type_to_string(ASTNodeType type) {
    switch (type) {
        case AST_GRAMMAR: return "GRAMMAR";
        case AST_RULE: return "RULE";
        case AST_PRODUCTION: return "PRODUCTION";
        case AST_SEQUENCE: return "SEQUENCE";
        case AST_CHOICE: return "CHOICE";
        case AST_TERMINAL: return "TERMINAL";
        case AST_NONTERMINAL: return "NONTERMINAL";
        case AST_OPTIONAL: return "OPTIONAL";
        case AST_REPETITION: return "REPETITION";
        case AST_PLUS_REPETITION: return "PLUS_REPETITION";
        case AST_ACTION: return "ACTION";
        default: return "UNKNOWN";
    }
}

void ast_node_print(ASTNode *node, int indent) {
    if (!node) return;
    
    for (int i = 0; i < indent; i++) {
        printf("  ");
    }
    
    printf("%s", ast_node_type_to_string(node->type));
    if (node->value) {
        printf(": %s", node->value);
    }
    printf("\n");
    
    for (int i = 0; i < node->child_count; i++) {
        ast_node_print(node->children[i], indent + 1);
    }
}