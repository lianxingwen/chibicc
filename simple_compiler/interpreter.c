#include "compiler.h"

int interpret(ASTNode *node, Environment *env) {
    if (!node) return 0;
    
    switch (node->type) {
        case AST_NUMBER:
            return node->data.number;
            
        case AST_VARIABLE:
            return env_get(env, node->data.variable);
            
        case AST_BINARY_OP: {
            int left = interpret(node->data.binary.left, env);
            int right = interpret(node->data.binary.right, env);
            
            switch (node->data.binary.op) {
                case '+': return left + right;
                case '-': return left - right;
                case '*': return left * right;
                case '/': 
                    if (right == 0) {
                        printf("错误：除零\n");
                        return 0;
                    }
                    return left / right;
                case '=': return left == right;  // == 比较
                case '<': return left < right;
                case '>': return left > right;
                default:
                    printf("错误：未知操作符 '%c'\n", node->data.binary.op);
                    return 0;
            }
        }
        
        case AST_ASSIGNMENT: {
            int value = interpret(node->data.assignment.value, env);
            env_set(env, node->data.assignment.var_name, value);
            return value;
        }
        
        case AST_PRINT: {
            int value = interpret(node->data.print.expression, env);
            printf("%d\n", value);
            return value;
        }
        
        case AST_IF: {
            int condition = interpret(node->data.if_stmt.condition, env);
            if (condition) {
                return interpret(node->data.if_stmt.then_stmt, env);
            } else if (node->data.if_stmt.else_stmt) {
                return interpret(node->data.if_stmt.else_stmt, env);
            }
            return 0;
        }
        
        case AST_WHILE: {
            int result = 0;
            while (interpret(node->data.while_stmt.condition, env)) {
                result = interpret(node->data.while_stmt.body, env);
            }
            return result;
        }
        
        case AST_BLOCK:
        case AST_PROGRAM: {
            int result = 0;
            for (int i = 0; i < node->data.block.count; i++) {
                result = interpret(node->data.block.statements[i], env);
            }
            return result;
        }
        
        default:
            printf("错误：未知AST节点类型\n");
            return 0;
    }
}