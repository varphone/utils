#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

enum Operation {
    K_NIL,
    K_REF,
    K_ASSIGN,
    K_AND,
    K_AND_ASSIGN,
    K_OR,
    K_OR_ASSIGN,
    K_XOR,
    K_XOR_ASSIGN,
    K_NOT,
    K_NOT_ASSIGN,
    K_LSH,
    K_LSH_ASSIGN,
    K_RSH,
    K_RSH_ASSIGN,
    K_ADD,
    K_ADD_ASSIGN,
    K_SUB,
    K_SUB_ASSIGN,
    K_MUL,
    K_MUL_ASSIGN,
    K_DIV,
    K_DIV_ASSIGN,
    K_MOD,
    K_MOD_ASSIGN,
};

const char* kOperations[] = {
    "Nil",
    "@",
    "=",
    "&",
    "&=",
    "|",
    "|=",
    "^",
    "^=",
    "!",
    "!=",
    "<<",
    "<<=",
    ">>",
    ">>=",
    "+",
    "+=",
    "-",
    "-=",
    "*",
    "*=",
    "/",
    "/=",
    "%",
    "%=",
};

const int kMaxStackItems = 4096;

struct StackItem {
    enum Operation op;
    long data;
};

struct Stack {
    struct StackItem items[4096];
    long index;
};

static void StackInit(struct Stack* s)
{
    memset(s, 0, sizeof(*s));
}

static void StackFini(struct Stack* s)
{
}

static void StackPush(struct Stack* s, enum Operation op, long data)
{
    s->items[s->index].op = op;
    s->items[s->index].data = data;
    s->index++;
}

static struct StackItem* StackPop(struct Stack* s)
{
    if (s->index < 0)
        return NULL;
    return &(s->items[s->index-- - 1]);
}

static void StackDump(struct Stack* s)
{
    printf("Stack size: %ld\n", s->index);
    for (long i = s->index; i >= 0; --i) {
        printf("[%04ld] %-3s %08lx\n", i, kOperations[s->items[i].op], s->items[i].data);
    }
}

static long StackItemCompute(struct StackItem* a, struct StackItem* b)
{
    long av = a->op == K_REF ? readl(a->data) : a->data;
    long bv = b->op == K_REF ? readl(b->data) : b->data;
    long rv = 0;
    switch (b->op) {
    case K_AND:
        rv = av & bv;
        break;
    case K_OR:
        rv = av | bv;
        break;
    case K_XOR:
        rv = av ^ bv;
        break;
    case K_NOT:
        rv = !av;
        break;
    case K_LSH:
        rv = av << bv;
        break;
    case K_RSH:
        rv = av > bv;
        break;
    case K_ADD:
        rv = av + bv;
        break;
    case K_SUB:
        rv = av - bv;
        break;
    }
    return rv;
}

static long getNumber(const char** l)
{
    long result = strtol(*l, NULL, 0);
    const char* p = *l;
    while (isdigit(*p) || isalpha(*p))
        p++;
    *l = p;
    return result;
}

static void skipBlank(const char** l)
{
    const char* p = *l;
    while (*p == ' ' || *p == '\t')
        p++;
    *l = p;
}

static void parse(const char* l, struct Stack* s)
{
    const char* p = l;
    skipBlank(&p);
    while (1) {
        int c = *p++;
        if (!c) break;
        switch (c) {
        case '@':
            skipBlank(&p);
            StackPush(s, K_REF, getNumber(&p));
            break;
        case '=':
            skipBlank(&p);
            StackPush(s, K_ASSIGN, getNumber(&p));
            break;
        case '&':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_AND_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_AND, getNumber(&p));
            }
            break;
        case '|':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_OR_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_OR, getNumber(&p));
            }
            break;
        case '^':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_XOR_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_XOR, getNumber(&p));
            }
            break;
        case '!':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_NOT_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_NOT, getNumber(&p));
            }
            break;
        case '<':
            if (*p == '<') {
                p++;
                if (*p == '=') {
                    p++;
                    skipBlank(&p);
                    StackPush(s, K_LSH_ASSIGN, getNumber(&p));
                } else {
                    skipBlank(&p);
                    StackPush(s, K_LSH, getNumber(&p));
                }
            }
            break;
        case '>':
            if (*p == '>') {
                p++;
                if (*p == '=') {
                    p++;
                    skipBlank(&p);
                    StackPush(s, K_RSH_ASSIGN, getNumber(&p));
                } else {
                    skipBlank(&p);
                    StackPush(s ,K_RSH, getNumber(&p));
                }
            }
            break;
        case '+':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_ADD_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_ADD, getNumber(&p));
            }
            break;
        case '-':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_SUB_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_SUB, getNumber(&p));
            }
            break;
        case '*':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_MUL_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_MUL, getNumber(&p));
            }
            break;
        case '/':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_DIV_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_DIV, getNumber(&p));
            }
            break;
        case '%':
            if (*p == '=') {
                p++;
                skipBlank(&p);
                StackPush(s, K_MOD_ASSIGN, getNumber(&p));
            } else {
                skipBlank(&p);
                StackPush(s, K_MOD, getNumber(&p));
            }
            break;
        case ' ':
        case '\t':
            break;
        default:
            p--;
            StackPush(s, K_NIL, getNumber(&p));
            break;
        }
    }
}

static void writel(long addr, long val)
{
}

static long readl(long addr)
{
    return 1;
}

static long compute(struct Stack* s)
{
    long result = 0, tmp = 0;
    int needAssigned = 0;
    struct StackItem* it = StackPop(s);
    struct StackItem* last = NULL;
    while (it) {
        switch (it->op) {
        case K_REF:
            if (last) {
                switch (last->op) {
                case K_ASSIGN:
                    writel(it->data, result);
                    break;
                case K_AND_ASSIGN:
                    tmp = readl(it->data) & result;
                    writel(it->data, tmp);
                    break;
                case K_OR_ASSIGN:
                    tmp = readl(it->data) | result;
                    writel(it->data, tmp);
                    break;
                case K_XOR_ASSIGN:
                    tmp = readl(it->data) ^ result;
                    writel(it->data, tmp);
                    break;
                case K_NOT_ASSIGN:
                    writel(it->data, !result);
                    break;
                case K_LSH_ASSIGN:
                    tmp = readl(it->data) << result;
                    writel(it->data, tmp);
                    break;
                case K_RSH_ASSIGN:
                    tmp = readl(it->data) >> result;
                    writel(it->data, tmp);
                    break;
                case K_ADD_ASSIGN:
                    tmp = readl(it->data) + result;
                    writel(it->data, tmp);
                    break;
                case K_SUB_ASSIGN:
                    tmp = readl(it->data) - result;
                    writel(it->data, tmp);
                    break;
                case K_MUL_ASSIGN:
                    tmp = readl(it->data) * result;
                    writel(it->data, tmp);
                    break;
                case K_DIV_ASSIGN:
                    tmp = readl(it->data) / result;
                    writel(it->data, tmp);
                    break;
                case K_MOD_ASSIGN:
                    tmp = readl(it->data) % result;
                    writel(it->data, tmp);
                    break;
                default:
                    break;
                result = readl(it->data);
                }
            }
            if (last) {
                switch (last->op) {
                case K_AND:
                    result = readl(it->data) & result;
                    break;
                case K_OR:
                    result = readl(it->data) | result;
                    break;
                case K_XOR:
                    result = readl(it->data) ^ result;
                    break;
                case K_NOT:
                    result = !result;
                    break;
                case K_LSH:
                    result = readl(it->data) << result;
                    break;
                case K_RSH:
                    result = readl(it->data) >> result;
                    break;
                case K_ADD:
                    result = readl(it->data) + result;
                    break;
                case K_SUB:
                    result = readl(it->data) - result;
                    break;
                case K_MUL:
                    result = readl(it->data) * result;
                    break;
                default:
                    break;
                }
            } else {
                result = readl(it->data);
            }
            break;
        case K_AND:
            result = result & it->data;
            break;
        case K_OR:
            result = result | it->data;
            break;
        case K_XOR:
            result = result ^ it->data;
            break;
        case K_NOT:
            result = !result;
            break;
        case K_LSH:
            result = result << it->data;
            break;
        case K_RSH:
            result = result >> it->data;
            break;
        case K_ADD:
            result = result + it->data;
            break;
        case K_SUB:
            result = result - it->data;
            break;
        case K_MUL:
            result = result * it->data;
            break;
        case K_DIV:
            result = result / it->data;
            break;
        case K_MOD:
            result = result % it->data;
            break;
        default:
            break;
        }
        last = it;
        it = StackPop(s);
    }
    return result;
}

int main(int argc, char** argv)
{
    struct Stack s;
    StackInit(&s);
    parse(argv[1], &s);
    StackDump(&s);
    printf("result: %ld\n", compute(&s));
    StackFini(&s);
    return 0;
}
