#include "compiler.h"

static void generate_expression(ASTNode *node, FILE *output);

static void generate_expression(ASTNode *node, FILE *output) {
    if (!node) return;
    
    switch (node->type) {
        case AST_NUMBER:
            fprintf(output, "%d", node->data.number);
            break;
            
        case AST_VARIABLE:
            fprintf(output, "get_var(\"%s\")", node->data.variable);
            break;
            
        case AST_BINARY_OP:
            fprintf(output, "(");
            generate_expression(node->data.binary.left, output);
            
            switch (node->data.binary.op) {
                case '+': fprintf(output, " + "); break;
                case '-': fprintf(output, " - "); break;
                case '*': fprintf(output, " * "); break;
                case '/': fprintf(output, " / "); break;
                case '=': fprintf(output, " == "); break;
                case '<': fprintf(output, " < "); break;
                case '>': fprintf(output, " > "); break;
            }
            
            generate_expression(node->data.binary.right, output);
            fprintf(output, ")");
            break;
            
        default:
            break;
    }
}

static void generate_statement(ASTNode *node, FILE *output, int indent);

static void print_indent(FILE *output, int indent) {
    for (int i = 0; i < indent; i++) {
        fprintf(output, "    ");
    }
}

static void generate_statement(ASTNode *node, FILE *output, int indent) {
    if (!node) return;
    
    switch (node->type) {
        case AST_ASSIGNMENT:
            print_indent(output, indent);
            fprintf(output, "set_var(\"%s\", ", node->data.assignment.var_name);
            generate_expression(node->data.assignment.value, output);
            fprintf(output, ");\n");
            break;
            
        case AST_PRINT:
            print_indent(output, indent);
            fprintf(output, "printf(\"%%d\\n\", ");
            generate_expression(node->data.print.expression, output);
            fprintf(output, ");\n");
            break;
            
        case AST_IF:
            print_indent(output, indent);
            fprintf(output, "if (");
            generate_expression(node->data.if_stmt.condition, output);
            fprintf(output, ") {\n");
            generate_statement(node->data.if_stmt.then_stmt, output, indent + 1);
            print_indent(output, indent);
            fprintf(output, "}");
            
            if (node->data.if_stmt.else_stmt) {
                fprintf(output, " else {\n");
                generate_statement(node->data.if_stmt.else_stmt, output, indent + 1);
                print_indent(output, indent);
                fprintf(output, "}");
            }
            fprintf(output, "\n");
            break;
            
        case AST_WHILE:
            print_indent(output, indent);
            fprintf(output, "while (");
            generate_expression(node->data.while_stmt.condition, output);
            fprintf(output, ") {\n");
            generate_statement(node->data.while_stmt.body, output, indent + 1);
            print_indent(output, indent);
            fprintf(output, "}\n");
            break;
            
        case AST_BLOCK:
            for (int i = 0; i < node->data.block.count; i++) {
                generate_statement(node->data.block.statements[i], output, indent);
            }
            break;
            
        default:
            // 表达式语句
            print_indent(output, indent);
            generate_expression(node, output);
            fprintf(output, ";\n");
            break;
    }
}

void compile_to_c(ASTNode *node, FILE *output) {
    // 生成C代码头部
    fprintf(output, "#include <stdio.h>\n");
    fprintf(output, "#include <stdlib.h>\n");
    fprintf(output, "#include <string.h>\n\n");
    
    // 变量管理代码
    fprintf(output, "typedef struct {\n");
    fprintf(output, "    char name[32];\n");
    fprintf(output, "    int value;\n");
    fprintf(output, "} Variable;\n\n");
    
    fprintf(output, "Variable vars[100];\n");
    fprintf(output, "int var_count = 0;\n\n");
    
    fprintf(output, "void set_var(const char* name, int value) {\n");
    fprintf(output, "    for (int i = 0; i < var_count; i++) {\n");
    fprintf(output, "        if (strcmp(vars[i].name, name) == 0) {\n");
    fprintf(output, "            vars[i].value = value;\n");
    fprintf(output, "            return;\n");
    fprintf(output, "        }\n");
    fprintf(output, "    }\n");
    fprintf(output, "    strcpy(vars[var_count].name, name);\n");
    fprintf(output, "    vars[var_count].value = value;\n");
    fprintf(output, "    var_count++;\n");
    fprintf(output, "}\n\n");
    
    fprintf(output, "int get_var(const char* name) {\n");
    fprintf(output, "    for (int i = 0; i < var_count; i++) {\n");
    fprintf(output, "        if (strcmp(vars[i].name, name) == 0) {\n");
    fprintf(output, "            return vars[i].value;\n");
    fprintf(output, "        }\n");
    fprintf(output, "    }\n");
    fprintf(output, "    printf(\"错误：未定义的变量 '%%s'\\n\", name);\n");
    fprintf(output, "    return 0;\n");
    fprintf(output, "}\n\n");
    
    // 主函数
    fprintf(output, "int main() {\n");
    
    if (node && node->type == AST_PROGRAM) {
        for (int i = 0; i < node->data.block.count; i++) {
            generate_statement(node->data.block.statements[i], output, 1);
        }
    }
    
    fprintf(output, "    return 0;\n");
    fprintf(output, "}\n");
}