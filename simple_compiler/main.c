#include "compiler.h"

void print_usage() {
    printf("简单算法编译器 v1.0\n");
    printf("用法：\n");
    printf("  compiler.exe -i <源文件>           # 解释执行\n");
    printf("  compiler.exe -c <源文件> <输出>    # 编译为C代码\n");
    printf("  compiler.exe -h                   # 显示帮助\n");
    printf("\n");
    printf("支持的语法：\n");
    printf("  变量赋值: x = 10;\n");
    printf("  算术运算: x = a + b * c;\n");
    printf("  打印输出: print x;\n");
    printf("  条件语句: if (x > 0) print x;\n");
    printf("  循环语句: while (x > 0) { print x; x = x - 1; }\n");
    printf("  比较运算: ==, <, >\n");
}

char* read_file(const char* filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        printf("错误：无法打开文件 '%s'\n", filename);
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

Token* tokenize(char *input, int *count) {
    Lexer *lexer = lexer_new(input);
    Token *tokens = malloc(sizeof(Token) * 1000);
    *count = 0;
    
    Token token;
    do {
        token = lexer_next_token(lexer);
        tokens[(*count)++] = token;
    } while (token.type != TOKEN_EOF && token.type != TOKEN_ERROR);
    
    lexer_free(lexer);
    return tokens;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        print_usage();
        return 1;
    }
    
    if (strcmp(argv[1], "-h") == 0) {
        print_usage();
        return 0;
    }
    
    if (strcmp(argv[1], "-i") == 0) {
        if (argc < 3) {
            printf("错误：请指定源文件\n");
            return 1;
        }
        
        char *input = read_file(argv[2]);
        if (!input) return 1;
        
        int token_count;
        Token *tokens = tokenize(input, &token_count);
        
        Parser *parser = parser_new(tokens, token_count);
        ASTNode *ast = parser_parse(parser);
        
        if (ast) {
            Environment *env = env_new();
            interpret(ast, env);
            env_free(env);
            ast_node_free(ast);
        } else {
            printf("解析失败\n");
        }
        
        parser_free(parser);
        free(tokens);
        free(input);
        
    } else if (strcmp(argv[1], "-c") == 0) {
        if (argc < 4) {
            printf("错误：请指定源文件和输出文件\n");
            return 1;
        }
        
        char *input = read_file(argv[2]);
        if (!input) return 1;
        
        int token_count;
        Token *tokens = tokenize(input, &token_count);
        
        Parser *parser = parser_new(tokens, token_count);
        ASTNode *ast = parser_parse(parser);
        
        if (ast) {
            FILE *output = fopen(argv[3], "w");
            if (output) {
                compile_to_c(ast, output);
                fclose(output);
                printf("编译成功：%s -> %s\n", argv[2], argv[3]);
            } else {
                printf("错误：无法创建输出文件 '%s'\n", argv[3]);
            }
            ast_node_free(ast);
        }
        
        parser_free(parser);
        free(tokens);
        free(input);
        
    } else {
        printf("错误：未知选项 '%s'\n", argv[1]);
        print_usage();
        return 1;
    }
    
    return 0;
}