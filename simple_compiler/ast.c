#include "compiler.h"

ASTNode* ast_node_new(ASTNodeType type) {
    ASTNode *node = malloc(sizeof(ASTNode));
    node->type = type;
    
    // 初始化联合体
    switch (type) {
        case AST_NUMBER:
            node->data.number = 0;
            break;
        case AST_VARIABLE:
            node->data.variable = NULL;
            break;
        case AST_BINARY_OP:
            node->data.binary.op = 0;
            node->data.binary.left = NULL;
            node->data.binary.right = NULL;
            break;
        case AST_ASSIGNMENT:
            node->data.assignment.var_name = NULL;
            node->data.assignment.value = NULL;
            break;
        case AST_PRINT:
            node->data.print.expression = NULL;
            break;
        case AST_IF:
            node->data.if_stmt.condition = NULL;
            node->data.if_stmt.then_stmt = NULL;
            node->data.if_stmt.else_stmt = NULL;
            break;
        case AST_WHILE:
            node->data.while_stmt.condition = NULL;
            node->data.while_stmt.body = NULL;
            break;
        case AST_BLOCK:
        case AST_PROGRAM:
            node->data.block.statements = NULL;
            node->data.block.count = 0;
            node->data.block.capacity = 0;
            break;
    }
    
    return node;
}

void ast_node_free(ASTNode *node) {
    if (!node) return;
    
    switch (node->type) {
        case AST_VARIABLE:
            free(node->data.variable);
            break;
        case AST_BINARY_OP:
            ast_node_free(node->data.binary.left);
            ast_node_free(node->data.binary.right);
            break;
        case AST_ASSIGNMENT:
            free(node->data.assignment.var_name);
            ast_node_free(node->data.assignment.value);
            break;
        case AST_PRINT:
            ast_node_free(node->data.print.expression);
            break;
        case AST_IF:
            ast_node_free(node->data.if_stmt.condition);
            ast_node_free(node->data.if_stmt.then_stmt);
            ast_node_free(node->data.if_stmt.else_stmt);
            break;
        case AST_WHILE:
            ast_node_free(node->data.while_stmt.condition);
            ast_node_free(node->data.while_stmt.body);
            break;
        case AST_BLOCK:
        case AST_PROGRAM:
            for (int i = 0; i < node->data.block.count; i++) {
                ast_node_free(node->data.block.statements[i]);
            }
            free(node->data.block.statements);
            break;
        default:
            break;
    }
    
    free(node);
}