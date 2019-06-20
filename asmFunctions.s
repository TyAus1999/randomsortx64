.intel_syntax noprefix
.text               #the first six parameters go into rdi, rsi, rdx, rcx, r8, and r9.
                    #rbx is preserved accross all function calls
    .global actualGen
    .global fib
    .global prob4
    .global bubbleSort
    .global fillArrayWithRandom64
    .global genRandom64
    .global missingNumber
    .global sortHighestNumber

        sortHighestNumber:#rdi pointer,rsi length
            #rbx is preserved
            cmp     rsi,1
            jl      _sortHighestNumberBad

            push    rbx
            push    rbp
            mov     rbp,rsp
            xor     rcx,rcx #counter
            xor     rdx,rdx #current Index of highest
            push    rcx #-8     highest place
            _sortHighestNumberL1:#largest number stored in rdx
                mov     rax,[rdi+rdx*8]
                cmp     rax,[rdi+rcx*8]
                jg      _sortHighestNumberL1Greater
                inc     rcx
                cmp     rcx,rsi
                jge     _sortHighestNumberL1Iterate
                jmp     _sortHighestNumberL1
                _sortHighestNumberL1Greater:
                    mov     rdx,rcx
                    jmp     _sortHighestNumberL1
                _sortHighestNumberL1Iterate:
                    #save largest value
                    mov     rax,[rdi+rdx*8]
                    #rax swap with [rbp-8]
                    push    rdx
                    mov     rdx,[rbp-8]
                    mov     rbx,[rdi+rdx*8]
                    mov     [rdi+rdx*8],rax
                    pop     rdx
                    mov     [rdi+rdx*8],rbx
                    incq    [rbp-8]

                    #save value to replace
                    #swap values
                    #set rcx to highest place +1


            mov     rsp,rbp
            pop     rbp
            pop     rbx

            _sortHighestNumberBad:
                mov     rax,0
                ret


        missingNumber:#rdi is pointer,rsi is length
        #rbx is preserved
        cmp     rsi,1
        jl      _missingNumberBad

        push    rbp
        mov     rbp,rsp



        mov     rsp,rbp
        pop     rbp

        _missingNumberBad:
            mov     rax,0
            ret

        fillArrayWithRandom64:#rdi is length
        #returns pointer to array
            cmp     rdi,0
            jle     _fillArrayWithRandom64Bad

            push    rbp
            mov     rbp,rsp

            push    rdi     #-8     length
            imul    rdi,8
            call    malloc@PLT
            push    rax     #-16    pointer
            pushq   0       #-24    counter

            _fillArrayWithRandom64L1:
                call    genRandom64
                mov     rdx,[rbp-16]
                mov     rcx,[rbp-24]
                mov     [rdx+rcx*8],rax

                inc     rcx
                mov     [rbp-24],rcx
                cmp     rcx,[rbp-8]
                jl      _fillArrayWithRandom64L1

            mov     rax,[rbp-16]
            mov     rsp,rbp
            pop     rbp
            ret
            _fillArrayWithRandom64Bad:
                mov     rax,0
                ret

        genRandom64:#returns 64
            call    rand@PLT
            push    rax
            call    rand@PLT
            shl     rax,32
            pop     rdx
            or      rax,rdx
            ret

        bubbleSort:#rdi is pointer rsi is length
        #returns pointer
            cmp     rsi,0
            jle     _bubbleSortBad
            cmp     rsi,1
            je      _bubbleSortMeme

            push    rbx
            push    rbp
            mov     rbp,rsp

            push    rdi     #-8 pointer
            push    rsi     #-16 length

            xor     rcx,rcx
            _bubbleSortL1:
                mov     rdx,[rbp-8]
                mov     rax,[rdx+rcx*8]
                inc     rcx
                cmp     rcx,[rbp-16]
                jge     _bubbleSortL1LengthLimit
                mov     rbx,[rdx+rcx*8]
                cmp     rax,rbx
                jl      _bubbleSortL1Swap
                jmp     _bubbleSortL1

            _bubbleSortEnd:
                mov     rax,[rbp-8]
                mov     rsp,rbp
                pop     rbp
                pop     rbx
                ret
            _bubbleSortL1LengthLimit:
                call    checkArray64
                cmp     rax,1
                je      _bubbleSortEnd
                xor     rcx,rcx
                jmp     _bubbleSortL1
            _bubbleSortL1Swap:
                mov     [rdx+rcx*8],rax
                dec     rcx
                mov     [rdx+rcx*8],rbx
                inc     rcx
                jmp     _bubbleSortL1
            _bubbleSortMeme:
                mov     rax,rdi
                ret
            _bubbleSortBad:
                mov     rax,0
                ret




        prob4:#rdi is pointer to array rsi is length
        #return number that has the largest value
            cmp     rsi,0
            jle     _prob4Bad
            
            xor     rcx,rcx
            _prob4L1:


            _prob4Bad:
                mov     rax,0
                ret

        fib:#rdi is iterations
            cmp     rdi,1
            jle     _fibBad
            xor     rax,rax
            push    rbx
            xor     rbx,rbx
            xor     rcx,rcx
            xor     rdx,rdx
            inc     rbx
            _fibL1:
                cmp     rdx,0
                je      _fibL1ToRbx
                dec     rdx
                add     rax,rbx
                _fibL1Main:
                inc     rcx
                cmp     rcx,rdi
                jne     _fibL1
                
            cmp     rax,rbx
            jg      _fibRax
            mov     rax,rbx
            _fibRax:
                pop     rbx
                ret
                _fibL1ToRbx:
                    add     rbx,rax
                    inc     rdx
                    jmp     _fibL1Main
            _fibBad:
                mov     rax,0
                ret
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

        checkArray64:#rdi is pointer, rsi is length
            #returns 0 for false and 1 for true
            cmp     rsi,0
            je      _checkArrayEnd
            
            xor     rcx,rcx
            mov     rdx,0xffffffffffffffff
            mov     rax,[rdi+rcx*8]
            cmp     rax,rdx
            jl      _checkArray64End
            mov     rdx,rax
            inc     rcx
            _checkArray64L1:
                mov     rax,[rdi+rcx*8]
                cmp     rax,rdx
                jg      _checkArray64End
                mov     rdx,rax
                inc     rcx
                cmp     rcx,rsi
                jl      _checkArray64L1

            mov     rax,1
            ret
            _checkArray64End:
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
