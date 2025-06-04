#include "codegen.h"
#include <stdarg.h>

CodeGenerator* codegen_new(FILE *output) {
    CodeGenerator *codegen = malloc(sizeof(CodeGenerator));
    codegen->output = output;
    codegen->indent_level = 0;
    return codegen;
}

void codegen_free(CodeGenerator *codegen) {
    if (codegen) {
        free(codegen);
    }
}

static void emit_indent(CodeGenerator *codegen) {
    for (int i = 0; i < codegen->indent_level; i++) {
        fprintf(codegen->output, "    ");
    }
}

static void emit_line(CodeGenerator *codegen, const char *format, ...) {
    va_list args;
    va_start(args, format);
    emit_indent(codegen);
    vfprintf(codegen->output, format, args);
    fprintf(codegen->output, "\n");
    va_end(args);
}

static void emit_header(CodeGenerator *codegen) {
    fprintf(codegen->output, "#include <stdio.h>\n");
    fprintf(codegen->output, "#include <stdlib.h>\n");
    fprintf(codegen->output, "#include <string.h>\n");
    fprintf(codegen->output, "#include <ctype.h>\n\n");
    
    fprintf(codegen->output, "typedef struct {\n");
    fprintf(codegen->output, "    char *input;\n");
    fprintf(codegen->output, "    int position;\n");
    fprintf(codegen->output, "    int length;\n");
    fprintf(codegen->output, "} ParseState;\n\n");
    
    fprintf(codegen->output, "ParseState* parse_state_new(char *input) {\n");
    fprintf(codegen->output, "    ParseState *state = malloc(sizeof(ParseState));\n");
    fprintf(codegen->output, "    state->input = input;\n");
    fprintf(codegen->output, "    state->position = 0;\n");
    fprintf(codegen->output, "    state->length = strlen(input);\n");
    fprintf(codegen->output, "    return state;\n");
    fprintf(codegen->output, "}\n\n");
    
    fprintf(codegen->output, "void parse_state_free(ParseState *state) {\n");
    fprintf(codegen->output, "    if (state) free(state);\n");
    fprintf(codegen->output, "}\n\n");
    
    fprintf(codegen->output, "void skip_whitespace(ParseState *state) {\n");
    fprintf(codegen->output, "    while (state->position < state->length && isspace(state->input[state->position])) {\n");
    fprintf(codegen->output, "        state->position++;\n");
    fprintf(codegen->output, "    }\n");
    fprintf(codegen->output, "}\n\n");
    
    fprintf(codegen->output, "int match_string(ParseState *state, const char *str) {\n");
    fprintf(codegen->output, "    int len = strlen(str);\n");
    fprintf(codegen->output, "    if (state->position + len > state->length) return 0;\n");
    fprintf(codegen->output, "    if (strncmp(state->input + state->position, str, len) == 0) {\n");
    fprintf(codegen->output, "        state->position += len;\n");
    fprintf(codegen->output, "        return 1;\n");
    fprintf(codegen->output, "    }\n");
    fprintf(codegen->output, "    return 0;\n");
    fprintf(codegen->output, "}\n\n");
}

static void generate_rule_function(CodeGenerator *codegen, ASTNode *rule);

static void generate_element_for_choice(CodeGenerator *codegen, ASTNode *element) {
    // This version doesn't use early returns, suitable for choice contexts
    switch (element->type) {
        case AST_TERMINAL:
            emit_line(codegen, "skip_whitespace(state);");
            emit_line(codegen, "if (!match_string(state, \"%s\")) choice_success = 0;", element->value);
            break;
            
        case AST_NONTERMINAL:
            emit_line(codegen, "if (!parse_%s(state)) choice_success = 0;", element->value);
            break;
            
        case AST_SEQUENCE:
            for (int i = 0; i < element->child_count; i++) {
                generate_element_for_choice(codegen, element->children[i]);
                emit_line(codegen, "if (!choice_success) return;");
            }
            break;
            
        default:
            emit_line(codegen, "// Unsupported element type in choice");
            emit_line(codegen, "choice_success = 0;");
            break;
    }
}

static void generate_element(CodeGenerator *codegen, ASTNode *element) {
    switch (element->type) {
        case AST_TERMINAL:
            emit_line(codegen, "skip_whitespace(state);");
            emit_line(codegen, "if (!match_string(state, \"%s\")) return 0;", element->value);
            break;
            
        case AST_NONTERMINAL:
            emit_line(codegen, "if (!parse_%s(state)) return 0;", element->value);
            break;
            
        case AST_SEQUENCE:
            for (int i = 0; i < element->child_count; i++) {
                generate_element(codegen, element->children[i]);
            }
            break;
            
        case AST_CHOICE:
            for (int i = 0; i < element->child_count; i++) {
                emit_line(codegen, "// Try choice %d", i + 1);
                emit_line(codegen, "{");
                codegen->indent_level++;
                emit_line(codegen, "int saved_pos = state->position;");
                
                if (element->children[i]->type == AST_TERMINAL) {
                    emit_line(codegen, "skip_whitespace(state);");
                    emit_line(codegen, "if (match_string(state, \"%s\")) return 1;", element->children[i]->value);
                } else if (element->children[i]->type == AST_NONTERMINAL) {
                    emit_line(codegen, "if (parse_%s(state)) return 1;", element->children[i]->value);
                } else if (element->children[i]->type == AST_SEQUENCE) {
                    // Handle sequences specially in choice context
                    emit_line(codegen, "int choice_success = 1;");
                    for (int j = 0; j < element->children[i]->child_count && j < 10; j++) {
                        emit_line(codegen, "if (choice_success) {");
                        codegen->indent_level++;
                        if (element->children[i]->children[j]->type == AST_TERMINAL) {
                            emit_line(codegen, "skip_whitespace(state);");
                            emit_line(codegen, "if (!match_string(state, \"%s\")) choice_success = 0;", element->children[i]->children[j]->value);
                        } else if (element->children[i]->children[j]->type == AST_NONTERMINAL) {
                            emit_line(codegen, "if (!parse_%s(state)) choice_success = 0;", element->children[i]->children[j]->value);
                        }
                        codegen->indent_level--;
                        emit_line(codegen, "}");
                    }
                    emit_line(codegen, "if (choice_success) return 1;");
                } else {
                    // For other complex elements, use recursive generation
                    emit_line(codegen, "int choice_success = 1;");
                    generate_element_for_choice(codegen, element->children[i]);
                    emit_line(codegen, "if (choice_success) return 1;");
                }
                
                emit_line(codegen, "state->position = saved_pos;");
                codegen->indent_level--;
                emit_line(codegen, "}");
            }
            emit_line(codegen, "return 0;");
            break;
            
        case AST_OPTIONAL:
            emit_line(codegen, "{");
            codegen->indent_level++;
            emit_line(codegen, "int saved_pos = state->position;");
            generate_element(codegen, element->children[0]);
            emit_line(codegen, "if (state->position == saved_pos) {");
            codegen->indent_level++;
            emit_line(codegen, "// Optional element not matched, restore position");
            emit_line(codegen, "state->position = saved_pos;");
            codegen->indent_level--;
            emit_line(codegen, "}");
            codegen->indent_level--;
            emit_line(codegen, "}");
            break;
            
        case AST_REPETITION:
            emit_line(codegen, "while (1) {");
            codegen->indent_level++;
            emit_line(codegen, "int saved_pos = state->position;");
            if (element->children[0]->type == AST_SEQUENCE) {
                // Handle sequence in repetition specially
                emit_line(codegen, "int seq_success = 1;");
                for (int i = 0; i < element->children[0]->child_count; i++) {
                    if (element->children[0]->children[i]->type == AST_CHOICE) {
                        emit_line(codegen, "int choice_matched = 0;");
                        for (int j = 0; j < element->children[0]->children[i]->child_count; j++) {
                            emit_line(codegen, "if (!choice_matched) {");
                            codegen->indent_level++;
                            emit_line(codegen, "int choice_pos = state->position;");
                            if (element->children[0]->children[i]->children[j]->type == AST_TERMINAL) {
                                emit_line(codegen, "skip_whitespace(state);");
                                emit_line(codegen, "if (match_string(state, \"%s\")) choice_matched = 1;", element->children[0]->children[i]->children[j]->value);
                            }
                            emit_line(codegen, "if (!choice_matched) state->position = choice_pos;");
                            codegen->indent_level--;
                            emit_line(codegen, "}");
                        }
                        emit_line(codegen, "if (!choice_matched) seq_success = 0;");
                    } else {
                        emit_line(codegen, "if (seq_success) {");
                        codegen->indent_level++;
                        generate_element(codegen, element->children[0]->children[i]);
                        codegen->indent_level--;
                        emit_line(codegen, "}");
                    }
                }
                emit_line(codegen, "if (!seq_success || state->position == saved_pos) break;");
            } else {
                generate_element(codegen, element->children[0]);
                emit_line(codegen, "if (state->position == saved_pos) break;");
            }
            codegen->indent_level--;
            emit_line(codegen, "}");
            break;
            
        case AST_PLUS_REPETITION:
            generate_element(codegen, element->children[0]);
            emit_line(codegen, "while (1) {");
            codegen->indent_level++;
            emit_line(codegen, "int saved_pos = state->position;");
            generate_element(codegen, element->children[0]);
            emit_line(codegen, "if (state->position == saved_pos) break;");
            codegen->indent_level--;
            emit_line(codegen, "}");
            break;
            
        default:
            break;
    }
}

static void generate_rule_function(CodeGenerator *codegen, ASTNode *rule) {
    fprintf(codegen->output, "int parse_%s(ParseState *state) {\n", rule->value);
    codegen->indent_level++;
    
    if (rule->child_count > 0) {
        generate_element(codegen, rule->children[0]);
    }
    
    codegen->indent_level--;
    fprintf(codegen->output, "}\n\n");
}

static void generate_forward_declarations(CodeGenerator *codegen, ASTNode *grammar) {
    for (int i = 0; i < grammar->child_count; i++) {
        ASTNode *rule = grammar->children[i];
        if (rule->type == AST_RULE) {
            fprintf(codegen->output, "int parse_%s(ParseState *state);\n", rule->value);
        }
    }
    fprintf(codegen->output, "\n");
}

static void generate_main_function(CodeGenerator *codegen, ASTNode *grammar) {
    fprintf(codegen->output, "int main(int argc, char *argv[]) {\n");
    fprintf(codegen->output, "    if (argc != 2) {\n");
    fprintf(codegen->output, "        printf(\"Usage: %%s <input>\\n\", argv[0]);\n");
    fprintf(codegen->output, "        return 1;\n");
    fprintf(codegen->output, "    }\n\n");
    
    fprintf(codegen->output, "    ParseState *state = parse_state_new(argv[1]);\n");
    
    // Use the first rule as the start rule
    if (grammar->child_count > 0) {
        ASTNode *first_rule = grammar->children[0];
        if (first_rule->type == AST_RULE) {
            fprintf(codegen->output, "    if (parse_%s(state)) {\n", first_rule->value);
            fprintf(codegen->output, "        skip_whitespace(state);\n");
            fprintf(codegen->output, "        if (state->position == state->length) {\n");
            fprintf(codegen->output, "            printf(\"Parse successful!\\n\");\n");
            fprintf(codegen->output, "            parse_state_free(state);\n");
            fprintf(codegen->output, "            return 0;\n");
            fprintf(codegen->output, "        }\n");
            fprintf(codegen->output, "    }\n");
        }
    }
    
    fprintf(codegen->output, "    printf(\"Parse failed at position %%d\\n\", state->position);\n");
    fprintf(codegen->output, "    parse_state_free(state);\n");
    fprintf(codegen->output, "    return 1;\n");
    fprintf(codegen->output, "}\n");
}

void codegen_generate_parser(CodeGenerator *codegen, ASTNode *grammar) {
    emit_header(codegen);
    generate_forward_declarations(codegen, grammar);
    
    for (int i = 0; i < grammar->child_count; i++) {
        ASTNode *rule = grammar->children[i];
        if (rule->type == AST_RULE) {
            generate_rule_function(codegen, rule);
        }
    }
    
    generate_main_function(codegen, grammar);
}