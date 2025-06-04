#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lexer.h"
#include "parser.h"
#include "ast.h"
#include "codegen.h"

char* read_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("Error: Could not open file %s\n", filename);
        return NULL;
    }
    
    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    fseek(file, 0, SEEK_SET);
    
    char *content = malloc(length + 1);
    fread(content, 1, length, file);
    content[length] = '\0';
    
    fclose(file);
    return content;
}

void print_usage(const char *program_name) {
    printf("Usage: %s <grammar_file> [output_file]\n", program_name);
    printf("  grammar_file: Input grammar file\n");
    printf("  output_file:  Output C parser file (default: parser.c)\n");
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3) {
        print_usage(argv[0]);
        return 1;
    }
    
    const char *grammar_file = argv[1];
    const char *output_file = argc == 3 ? argv[2] : "generated_parser.c";
    
    // Read grammar file
    char *grammar_content = read_file(grammar_file);
    if (!grammar_content) {
        return 1;
    }
    
    printf("Parsing grammar from %s...\n", grammar_file);
    
    // Tokenize
    Lexer *lexer = lexer_new(grammar_content);
    
    // Parse
    Parser *parser = parser_new(lexer);
    ASTNode *grammar_ast = parser_parse_grammar(parser);
    
    if (parser->has_error || !grammar_ast) {
        printf("Failed to parse grammar\n");
        if (parser->error_message) {
            printf("Error: %s\n", parser->error_message);
        }
        parser_free(parser);
        lexer_free(lexer);
        free(grammar_content);
        return 1;
    }
    
    printf("Grammar parsed successfully!\n");
    printf("AST:\n");
    ast_node_print(grammar_ast, 0);
    
    // Generate parser
    FILE *output = fopen(output_file, "w");
    if (!output) {
        printf("Error: Could not create output file %s\n", output_file);
        ast_node_free(grammar_ast);
        parser_free(parser);
        lexer_free(lexer);
        free(grammar_content);
        return 1;
    }
    
    printf("Generating parser to %s...\n", output_file);
    CodeGenerator *codegen = codegen_new(output);
    codegen_generate_parser(codegen, grammar_ast);
    
    fclose(output);
    printf("Parser generated successfully!\n");
    
    // Cleanup
    codegen_free(codegen);
    ast_node_free(grammar_ast);
    parser_free(parser);
    lexer_free(lexer);
    free(grammar_content);
    
    return 0;
}