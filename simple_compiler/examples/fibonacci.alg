// 斐波那契数列前10项
a = 0;
b = 1;
i = 0;

print a;
print b;

while (i < 8) {
    c = a + b;
    print c;
    a = b;
    b = c;
    i = i + 1;
}