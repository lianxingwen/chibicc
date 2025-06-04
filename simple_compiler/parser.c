#include "compiler.h"

static char* my_strdup_local(const char* s) {
    if (!s) return NULL;
    size_t len = strlen(s) + 1;
    char* copy = malloc(len);
    if (copy) memcpy(copy, s, len);
    return copy;
}

Parser* parser_new(Token *tokens, int count) {
    Parser *parser = malloc(sizeof(Parser));
    parser->tokens = tokens;
    parser->position = 0;
    parser->count = count;
    return parser;
}

void parser_free(Parser *parser) {
    if (parser) {
        free(parser);
    }
}

static Token current_token(Parser *parser) {
    if (parser->position >= parser->count) {
        Token eof = {TOKEN_EOF, NULL, 0, 0};
        return eof;
    }
    return parser->tokens[parser->position];
}

static void advance(Parser *parser) {
    if (parser->position < parser->count) {
        parser->position++;
    }
}

static int match(Parser *parser, TokenType type) {
    return current_token(parser).type == type;
}

static int consume(Parser *parser, TokenType type) {
    if (match(parser, type)) {
        advance(parser);
        return 1;
    }
    return 0;
}

// 前向声明
static ASTNode* parse_expression(Parser *parser);
static ASTNode* parse_statement(Parser *parser);
static ASTNode* parse_block(Parser *parser);

static ASTNode* parse_primary(Parser *parser) {
    Token token = current_token(parser);
    
    if (token.type == TOKEN_NUMBER) {
        advance(parser);
        ASTNode *node = ast_node_new(AST_NUMBER);
        node->data.number = atoi(token.value);
        return node;
    }
    
    if (token.type == TOKEN_IDENTIFIER) {
        advance(parser);
        ASTNode *node = ast_node_new(AST_VARIABLE);
        node->data.variable = my_strdup_local(token.value);
        return node;
    }
    
    if (token.type == TOKEN_LPAREN) {
        advance(parser);
        ASTNode *node = parse_expression(parser);
        consume(parser, TOKEN_RPAREN);
        return node;
    }
    
    return NULL;
}

static ASTNode* parse_factor(Parser *parser) {
    return parse_primary(parser);
}

static ASTNode* parse_term(Parser *parser) {
    ASTNode *left = parse_factor(parser);
    
    while (match(parser, TOKEN_MULTIPLY) || match(parser, TOKEN_DIVIDE)) {
        Token op = current_token(parser);
        advance(parser);
        ASTNode *right = parse_factor(parser);
        
        ASTNode *node = ast_node_new(AST_BINARY_OP);
        node->data.binary.op = op.value[0];
        node->data.binary.left = left;
        node->data.binary.right = right;
        left = node;
    }
    
    return left;
}

static ASTNode* parse_expression(Parser *parser) {
    ASTNode *left = parse_term(parser);
    
    while (match(parser, TOKEN_PLUS) || match(parser, TOKEN_MINUS) ||
           match(parser, TOKEN_EQ) || match(parser, TOKEN_LT) || match(parser, TOKEN_GT)) {
        Token op = current_token(parser);
        advance(parser);
        ASTNode *right = parse_term(parser);
        
        ASTNode *node = ast_node_new(AST_BINARY_OP);
        if (op.type == TOKEN_EQ) {
            node->data.binary.op = '=';  // 用 = 表示 ==
        } else {
            node->data.binary.op = op.value[0];
        }
        node->data.binary.left = left;
        node->data.binary.right = right;
        left = node;
    }
    
    return left;
}

static ASTNode* parse_assignment(Parser *parser) {
    if (match(parser, TOKEN_IDENTIFIER)) {
        Token var = current_token(parser);
        advance(parser);
        
        if (consume(parser, TOKEN_ASSIGN)) {
            ASTNode *value = parse_expression(parser);
            ASTNode *node = ast_node_new(AST_ASSIGNMENT);
            node->data.assignment.var_name = my_strdup_local(var.value);
            node->data.assignment.value = value;
            return node;
        } else {
            // 回退，这是一个表达式
            parser->position--;
            return parse_expression(parser);
        }
    }
    
    return parse_expression(parser);
}

static ASTNode* parse_print(Parser *parser) {
    advance(parser); // 跳过 print
    ASTNode *expr = parse_expression(parser);
    ASTNode *node = ast_node_new(AST_PRINT);
    node->data.print.expression = expr;
    return node;
}

static ASTNode* parse_if(Parser *parser) {
    advance(parser); // 跳过 if
    consume(parser, TOKEN_LPAREN);
    ASTNode *condition = parse_expression(parser);
    consume(parser, TOKEN_RPAREN);
    
    ASTNode *then_stmt = parse_statement(parser);
    ASTNode *else_stmt = NULL;
    
    if (consume(parser, TOKEN_ELSE)) {
        else_stmt = parse_statement(parser);
    }
    
    ASTNode *node = ast_node_new(AST_IF);
    node->data.if_stmt.condition = condition;
    node->data.if_stmt.then_stmt = then_stmt;
    node->data.if_stmt.else_stmt = else_stmt;
    return node;
}

static ASTNode* parse_while(Parser *parser) {
    advance(parser); // 跳过 while
    consume(parser, TOKEN_LPAREN);
    ASTNode *condition = parse_expression(parser);
    consume(parser, TOKEN_RPAREN);
    
    ASTNode *body = parse_statement(parser);
    
    ASTNode *node = ast_node_new(AST_WHILE);
    node->data.while_stmt.condition = condition;
    node->data.while_stmt.body = body;
    return node;
}

static ASTNode* parse_block(Parser *parser) {
    advance(parser); // 跳过 {
    
    ASTNode *block = ast_node_new(AST_BLOCK);
    block->data.block.statements = malloc(sizeof(ASTNode*) * 10);
    block->data.block.count = 0;
    block->data.block.capacity = 10;
    
    while (!match(parser, TOKEN_RBRACE) && !match(parser, TOKEN_EOF)) {
        ASTNode *stmt = parse_statement(parser);
        if (stmt) {
            if (block->data.block.count >= block->data.block.capacity) {
                block->data.block.capacity *= 2;
                block->data.block.statements = realloc(block->data.block.statements,
                    sizeof(ASTNode*) * block->data.block.capacity);
            }
            block->data.block.statements[block->data.block.count++] = stmt;
        }
    }
    
    consume(parser, TOKEN_RBRACE);
    return block;
}

static ASTNode* parse_statement(Parser *parser) {
    if (match(parser, TOKEN_PRINT)) {
        ASTNode *stmt = parse_print(parser);
        consume(parser, TOKEN_SEMICOLON);
        return stmt;
    }
    
    if (match(parser, TOKEN_IF)) {
        return parse_if(parser);
    }
    
    if (match(parser, TOKEN_WHILE)) {
        return parse_while(parser);
    }
    
    if (match(parser, TOKEN_LBRACE)) {
        return parse_block(parser);
    }
    
    ASTNode *stmt = parse_assignment(parser);
    consume(parser, TOKEN_SEMICOLON);
    return stmt;
}

ASTNode* parser_parse(Parser *parser) {
    ASTNode *program = ast_node_new(AST_PROGRAM);
    program->data.block.statements = malloc(sizeof(ASTNode*) * 10);
    program->data.block.count = 0;
    program->data.block.capacity = 10;
    
    while (!match(parser, TOKEN_EOF)) {
        ASTNode *stmt = parse_statement(parser);
        if (stmt) {
            if (program->data.block.count >= program->data.block.capacity) {
                program->data.block.capacity *= 2;
                program->data.block.statements = realloc(program->data.block.statements,
                    sizeof(ASTNode*) * program->data.block.capacity);
            }
            program->data.block.statements[program->data.block.count++] = stmt;
        }
    }
    
    return program;
}