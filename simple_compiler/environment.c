#include "compiler.h"

static char* my_strdup_local(const char* s) {
    if (!s) return NULL;
    size_t len = strlen(s) + 1;
    char* copy = malloc(len);
    if (copy) memcpy(copy, s, len);
    return copy;
}

Environment* env_new() {
    Environment *env = malloc(sizeof(Environment));
    env->vars = malloc(sizeof(Variable) * 10);
    env->count = 0;
    env->capacity = 10;
    return env;
}

void env_free(Environment *env) {
    if (env) {
        for (int i = 0; i < env->count; i++) {
            free(env->vars[i].name);
        }
        free(env->vars);
        free(env);
    }
}

void env_set(Environment *env, char *name, int value) {
    // 查找是否已存在
    for (int i = 0; i < env->count; i++) {
        if (strcmp(env->vars[i].name, name) == 0) {
            env->vars[i].value = value;
            return;
        }
    }
    
    // 添加新变量
    if (env->count >= env->capacity) {
        env->capacity *= 2;
        env->vars = realloc(env->vars, sizeof(Variable) * env->capacity);
    }
    
    env->vars[env->count].name = my_strdup_local(name);
    env->vars[env->count].value = value;
    env->count++;
}

int env_get(Environment *env, char *name) {
    for (int i = 0; i < env->count; i++) {
        if (strcmp(env->vars[i].name, name) == 0) {
            return env->vars[i].value;
        }
    }
    
    printf("错误：未定义的变量 '%s'\n", name);
    return 0;
}