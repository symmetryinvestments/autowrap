/**
   Boilerplate code to initialise the D runtime.
 */

extern int rt_init(void);
extern int rt_term(void);

__attribute__((__constructor__)) void dinit_pynih(void) {
    rt_init();
}
__attribute__((__destructor__)) void dterm_pynih(void) {
    rt_term();
}
