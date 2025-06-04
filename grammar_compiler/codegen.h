#ifndef CODEGEN_H
#define CODEGEN_H

#include "ast.h"
#include <stdio.h>

typedef struct {
    FILE *output;
    int indent_level;
} CodeGenerator;

CodeGenerator* codegen_new(FILE *output);
void codegen_free(CodeGenerator *codegen);
void codegen_generate_parser(CodeGenerator *codegen, ASTNode *grammar);

#endif