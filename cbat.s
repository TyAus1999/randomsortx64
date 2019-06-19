.intel_syntax noprefix
#the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
#rbx is preserved accross all function calls
.text
    .global sleepIn
    sleepIn:#rdi weekday (bool), rsi vacation (bool)
        cmp     rsi,1
        je      _sleepInYes
        cmp     rdi,0
        je      _sleepInNo
        _sleepInYes:
            mov     rax,1
            ret
        _sleepInNo:
            mov     rax,0
            ret

