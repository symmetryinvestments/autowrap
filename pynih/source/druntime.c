/**
   Boilerplate code to initialise the D runtime.
 */

extern int rt_init(void);
extern int rt_term(void);

__attribute__((__constructor__)) void dinit(void) {
    rt_init();
}
__attribute__((__destructor__)) void dterm(void) {
    rt_term();
}
