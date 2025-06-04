#define _GNU_SOURCE
#include "parser.h"

Parser* parser_new(Lexer *lexer) {
    Parser *parser = malloc(sizeof(Parser));
    parser->lexer = lexer;
    parser->current_token = lexer_next_token(lexer);
    parser->has_error = 0;
    parser->error_message = NULL;
    return parser;
}

void parser_free(Parser *parser) {
    if (parser) {
        token_free(&parser->current_token);
        free(parser->error_message);
        free(parser);
    }
}

void parser_error(Parser *parser, char *message) {
    parser->has_error = 1;
    parser->error_message = strdup(message);
    printf("Parse error at line %d, column %d: %s\n", 
           parser->current_token.line, parser->current_token.column, message);
}

static void advance_token(Parser *parser) {
    token_free(&parser->current_token);
    parser->current_token = lexer_next_token(parser->lexer);
}

static int match_token(Parser *parser, TokenType type) {
    return parser->current_token.type == type;
}

static int consume_token(Parser *parser, TokenType type) {
    if (match_token(parser, type)) {
        advance_token(parser);
        return 1;
    }
    return 0;
}

static void skip_newlines(Parser *parser) {
    while (match_token(parser, TOKEN_NEWLINE)) {
        advance_token(parser);
    }
}

// Forward declarations
static ASTNode* parse_rule(Parser *parser);
static ASTNode* parse_production(Parser *parser);
static ASTNode* parse_sequence(Parser *parser);
static ASTNode* parse_element(Parser *parser);

static ASTNode* parse_element(Parser *parser) {
    ASTNode *node = NULL;
    
    if (match_token(parser, TOKEN_IDENTIFIER)) {
        node = ast_node_new(AST_NONTERMINAL, parser->current_token.value);
        advance_token(parser);
    } else if (match_token(parser, TOKEN_STRING)) {
        node = ast_node_new(AST_TERMINAL, parser->current_token.value);
        advance_token(parser);
    } else if (match_token(parser, TOKEN_LPAREN)) {
        advance_token(parser);
        node = parse_production(parser);
        if (!consume_token(parser, TOKEN_RPAREN)) {
            parser_error(parser, "Expected ')'");
            return node;
        }
    } else {
        parser_error(parser, "Expected identifier, string, or '('");
        return NULL;
    }
    
    // Handle postfix operators
    if (match_token(parser, TOKEN_STAR)) {
        ASTNode *rep = ast_node_new(AST_REPETITION, NULL);
        ast_node_add_child(rep, node);
        node = rep;
        advance_token(parser);
    } else if (match_token(parser, TOKEN_PLUS)) {
        ASTNode *rep = ast_node_new(AST_PLUS_REPETITION, NULL);
        ast_node_add_child(rep, node);
        node = rep;
        advance_token(parser);
    } else if (match_token(parser, TOKEN_QUESTION)) {
        ASTNode *opt = ast_node_new(AST_OPTIONAL, NULL);
        ast_node_add_child(opt, node);
        node = opt;
        advance_token(parser);
    }
    
    return node;
}

static ASTNode* parse_sequence(Parser *parser) {
    ASTNode *sequence = ast_node_new(AST_SEQUENCE, NULL);
    
    ASTNode *element = parse_element(parser);
    if (!element) {
        ast_node_free(sequence);
        return NULL;
    }
    ast_node_add_child(sequence, element);
    
    while (!match_token(parser, TOKEN_PIPE) && 
           !match_token(parser, TOKEN_SEMICOLON) && 
           !match_token(parser, TOKEN_RPAREN) &&
           !match_token(parser, TOKEN_NEWLINE) &&
           !match_token(parser, TOKEN_EOF)) {
        element = parse_element(parser);
        if (!element) break;
        ast_node_add_child(sequence, element);
    }
    
    if (sequence->child_count == 1) {
        ASTNode *single = sequence->children[0];
        sequence->children[0] = NULL;
        ast_node_free(sequence);
        return single;
    }
    
    return sequence;
}

static ASTNode* parse_production(Parser *parser) {
    ASTNode *production = ast_node_new(AST_CHOICE, NULL);
    
    ASTNode *sequence = parse_sequence(parser);
    if (!sequence) {
        ast_node_free(production);
        return NULL;
    }
    ast_node_add_child(production, sequence);
    
    while (match_token(parser, TOKEN_PIPE)) {
        advance_token(parser);
        sequence = parse_sequence(parser);
        if (!sequence) break;
        ast_node_add_child(production, sequence);
    }
    
    if (production->child_count == 1) {
        ASTNode *single = production->children[0];
        production->children[0] = NULL;
        ast_node_free(production);
        return single;
    }
    
    return production;
}

static ASTNode* parse_rule(Parser *parser) {
    if (!match_token(parser, TOKEN_IDENTIFIER)) {
        parser_error(parser, "Expected rule name");
        return NULL;
    }
    
    ASTNode *rule = ast_node_new(AST_RULE, parser->current_token.value);
    advance_token(parser);
    
    if (!consume_token(parser, TOKEN_COLON)) {
        parser_error(parser, "Expected ':' after rule name");
        ast_node_free(rule);
        return NULL;
    }
    
    ASTNode *production = parse_production(parser);
    if (!production) {
        ast_node_free(rule);
        return NULL;
    }
    ast_node_add_child(rule, production);
    
    if (!consume_token(parser, TOKEN_SEMICOLON)) {
        parser_error(parser, "Expected ';' after rule");
        ast_node_free(rule);
        return NULL;
    }
    
    return rule;
}

ASTNode* parser_parse_grammar(Parser *parser) {
    ASTNode *grammar = ast_node_new(AST_GRAMMAR, NULL);
    
    skip_newlines(parser);
    
    while (!match_token(parser, TOKEN_EOF)) {
        if (match_token(parser, TOKEN_NEWLINE)) {
            advance_token(parser);
            continue;
        }
        
        ASTNode *rule = parse_rule(parser);
        if (!rule) {
            if (!parser->has_error) {
                parser_error(parser, "Failed to parse rule");
            }
            ast_node_free(grammar);
            return NULL;
        }
        ast_node_add_child(grammar, rule);
        
        skip_newlines(parser);
    }
    
    return grammar;
}