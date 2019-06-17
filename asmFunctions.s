.intel_syntax noprefix
.text               #the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
    
    .global actualGen
        test:
            mov eax,2
            ret
        test2:
            mov eax,edi
            ret
        callRandTest:
            call rand@PLT   #returns random 32 bit to %eax
            ret
        

        mallocExample:
            mov 	edi,4           #amount of bytes
            call	malloc@PLT      #call function returns pointer to rax
            ret
        freeExample:
            movq	rdi,rax         #move pointer to the param register
            call	free@PLT        #call free
            ret


        generatePointer64:#works rdi amount of numbers
        #returns rax pointer
            cmp     rdi,0
            jle     _generatePointer64End
            push    rdi
            imul    rdi,4
            call    malloc@PLT
            pop     rdi
            ret
            _generatePointer64End:
                mov     rax,0
                ret

        fillArrayWith32:#rdi length, rsi is pointer to array
        #returns rax pointer rbx length
            cmp     rdi,0
            jle     _fillArrayWith32End
            cmp     rsi,0
            je      _fillArrayWith32End
            push    rbp         #[rbp]
            mov     rbp,rsp
            xor     rcx,rcx
            push    rdi#length  [rbp-8]
            push    rsi#pointer [rbp-16]
            push    rcx#counter [rbp-24]
            _fillArrayWith32L1:
                call    rand@PLT    #does not change rbx
                xor     edx,edx
                mov     ebx,100
                div     ebx
                mov     eax,edx
                mov     rcx,[rbp-24]#counter
                mov     rbx,[rbp-8] #length
                mov     rdx,[rbp-16]#pointer

                mov     [rdx+rcx*4],eax
                inc     rcx
                mov     [rbp-24],rcx
                cmp     rcx,rbx
                jl     _fillArrayWith32L1
            pop     rax
            pop     rax
            pop     rbx
            pop     rbp
            ret     #rax is pointer, rbx is length
            _fillArrayWith32End:
                mov     rax,0
                ret

        checkArray:#rdi is pointer to array, rsi is length
        #returns 0 for false and 1 for true
            cmp     rdi,0
            je      _checkArrayEnd
            cmp     rsi,0
            je      _checkArrayEnd
            xor     rcx,rcx
            xor     rbx,rbx
            _checkArrayL1:
                mov     eax,[rdi+rcx*4]
                cmp     eax,ebx
                jl      _checkArrayEnd
                mov     ebx,eax
                inc     rcx
                cmp     rsi,rcx
                jne     _checkArrayL1
            mov     rax,1
            ret
            _checkArrayEnd:
                mov     rax,0
                ret

        shiftArrayAround:#rdi is pointer to array, rsi is length
        #returns pointer(rax) and length(rbx)
            cmp     rdi,0
            je      _shiftArrayAroundEnd
            cmp     rsi,1
            jl      _shiftArrayAroundEnd
            push    rbp
            mov     rbp,rsp
            #figure out where to put the number in the array
            #gen random lower bits to determine where the number goes

            
            #first number out
            #should first number replace second number?
            #yes
                #swap first and second number
            #no
                #check second number

            #get value at index
            #gen random number to determine how many times to insert numbers at random
            #gen random number to determine what index to put it in
            push    rdi#-8  pointer
            push    rsi#-16 length
            xor     rcx,rcx
            push    rcx#-24 counter

            #how many times to shuffle,amount=length

            _shiftArrayAroundL2:
                call    rand@PLT
                xor     edx,edx
                mov     ecx,[rbp-16]
                div     ecx

                mov     rcx,[rbp-24]    #counter
                mov     rsi,[rbp-8]     #pointer
                xor     rax,rax
                mov     eax,[rsi+rcx*4] #current value
                push    rax
                mov     eax,[rsi+rdx*4]
                mov     [rsi+rcx*4],eax
                pop     rax
                mov     [rsi+rdx*4],eax
                inc     rcx
                mov     [rbp-24],rcx
                cmp     rcx,[rbp-16]
                jne     _shiftArrayAroundL2
                mov     rax,[rbp-8]
                mov     rbx,[rbp-16]
                mov     rsp,rbp
                pop     rbp
                ret
            _shiftArrayAroundEnd:
                mov     rax,0
                ret

        actualGen:#need to make sure that everything gets popped off the stack
        #Note to self, ALWAYS free memory :)
            cmp     rdi,0
            jle     _actualGenEnd
            #generate the amount in rdi
            #randomize by address
            #check for order
            push    rbp
            mov     rbp,rsp
            push    rdi     #-8     length
            call    generatePointer64
            push    rax     #-16    pointer
            mov     rdi,[rbp-8]
            mov     rsi,[rbp-16]
            call    fillArrayWith32
            push    0       #-24    counter
            _actualGenL1:
                mov     rdi,rax
                mov     rsi,rbx
                call    checkArray
                cmp     rax,1
                je     _actualGenL1End
                mov     rcx,[rbp-24]
                inc     rcx
                mov     [rbp-24],rcx
                mov     rdi,[rbp-16]
                mov     rsi,[rbp-8]
                call    shiftArrayAround
                jmp     _actualGenL1
            _actualGenL1End:
                mov     rdi,[rbp-16]
                call    free@PLT
                mov     rax,[rbp-24]
                mov     rsp,rbp
                pop     rbp
                ret
            _actualGenEnd:
                mov     rax,0
                ret

    .data