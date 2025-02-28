#ifndef _FENV_H
#define _FENV_H

#define FE_TONEAREST  0
#define FE_DOWNWARD   1
#define FE_UPWARD     2
#define FE_TOWARDZERO 3
#define FE_OVERFLOW   (1 << 3)  // Falls nicht definiert

static inline int feclearexcept(int excepts) { return 0; }
static inline int fegetexceptflag(int *flagp, int excepts) { return 0; }
static inline int feraiseexcept(int excepts) { return 0; }
static inline int fesetexceptflag(const int *flagp, int excepts) { return 0; }
static inline int fetestexcept(int excepts) { return 0; }
static inline int fegetround(void) { return FE_TONEAREST; }
static inline int fesetround(int mode) { return 0; }
static inline int fegetenv(void *envp) { return 0; }
static inline int fesetenv(const void *envp) { return 0; }

#endif
