extern void ler_int(int *);
extern void escrever_int(int);

int main(void)
{
    int a;
    ler_int(&a);
    escrever_int(a);
}