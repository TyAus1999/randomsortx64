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
    .global sysCallTest
    .global whileLoopTest
    .global primeNumberFinder
    .global setCursor
    .global writeChar
    .global pokerHand
    .global echoTest
    .global printfGraphicsTest
    .global floatingPointTest
    .global asmPI
    .global evenOdd

        evenOdd:
            mov     rax,1
            and     rax,rdi
            ret

        asmPI:#rdi max
            push	rbx
            push	rbp
            mov	    rbp,rsp

            mov     rcx,1
            xor     rax,rax
            cvtsi2sd xmm0,rax
            cvtsi2sd xmm1,rax
            xor     rbx,rbx
            asmPIL1:
                cmp     rcx,rdi
                jge     asmPIEnd
                cmp     rbx,0
                jne     asmPIL1False
                mov     rax,4
                cvtsi2sd xmm1,rax
                cvtsi2sd xmm2,rcx
                divpd   xmm1,xmm2
                psubq   xmm0,xmm1

                mov     rbx,1
                add     rcx,2
                jmp     asmPIL1
            asmPIL1False:
                xor     rbx,rbx
                mov     rax,4
                cvtsi2sd xmm1,rax
                cvtsi2sd xmm2,rcx
                divpd   xmm1,xmm2
                paddq   xmm0,xmm1
                
                add     rcx,2
                jmp     asmPIL1
            
            asmPIEnd:

            mov	    rsp,rbp
            pop	    rbp
            pop	    rbx
            ret

        floatingPointTest:
            push	rbx
            push	rbp
            mov	    rbp,rsp

            cvtsi2sd    xmm0,rdi
            cvtsi2sd    xmm1,rdi
            mulsd       xmm0,xmm1

            mov	    rsp,rbp
            pop	    rbp
            pop	    rbx
            ret

        printfGraphicsTest:
            push    rbx
            push    rbp
            mov     rbp,rsp

            #screen size 50x20

            mov     rax,51  #Add extra byte for 0x0a padding (New line Character)
            mov     rbx,20
            mul     rbx
            push    rax     #-8 amount of allocated bytes

            mov     rdi,rax
            call    malloc@PLT
            push    rax     #-16 graphics memory pointer

            mov     rdi,16
            call    malloc@PLT
            push    rax
            mov     qword ptr[rax],10
            mov     qword ptr[rax+8],10000
            mov     rdi,rax
            mov     rax,35
            mov     rsi,0
            int     0x80
            pop     rdi
            call    free@PLT

            #printf("%s"-addr rdi, "replace string"-addr rsi)
            call    _printfGLClear

            mov     rdi,[rbp-16]
            call    free@PLT
            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret
            _printfGLRefresh:   #rdi-graphics memory pointer
                push    rbx
                push    rbp
                mov     rbp,rsp
                push    rdi     #-8

                mov     rdi,2
                call    malloc@PLT
                push    rax     #-16
                mov     byte ptr[rax],0x25
                mov     byte ptr[rax+1],0x73

                mov     rdi,rax
                mov     rsi,[rbp-8]
                call    printf@PLT

                mov     rsp,rbp
                pop     rbp
                pop     rbx  
                ret
            _printfGLSetCharAt: #rdi-x,rsi-y,rdx-graphics pointer,cl-Character
                call    _printfGLGetCursor
                mov     byte ptr[rax],cl
                ret
            _printfGLGetCursor: #rdi-x,rsi-y, rdx-graphics pointer, returns pointer
                cmp     rsi,0
                je      _printfGLGetCursor0Y
                mov     rax,rdx
                add     rax,rdi
                dec     rax
                ret
                _printfGLGetCursor0Y:
                push    rbx
                mov     rax,51
                mov     rbx,rsi
                dec     rbx
                mul     rbx
                add     rax,rdi
                mov     rbx,rdx
                add     rbx,rax
                mov     rax,rbx
                pop     rbx
                ret
            _printfGLClear:
                push    rbx
                push    rbp
                mov     rbp,rsp
                
                mov     rdi,30
                call    malloc@PLT
                push    rax     #-8
                xor     rcx,rcx
                _printfGLClearL1:
                    mov     byte ptr[rax+rcx],0x0a
                    inc     rcx
                    cmp     rcx,30
                    jl      _printfGLClearL1
                
                xor     rsi,rsi
                mov     rdi,rax
                xor     rax,rax
                call    printf@PLT

                mov     rdi,[rbp-8]
                call    free@PLT

                mov     rsp,rbp
                pop     rbp
                pop     rbx
                ret

        echoTest:
            push    rbx
            push    rbp
            mov     rbp,rsp

            mov     rdi,5
            call    malloc@PLT
            push    rax     #-8
            mov     bl,0x21
            mov     [rax],bl
            mov     [rax+1],bl
            mov     [rax+2],bl
            mov     [rax+3],bl
            mov     [rax+4],bl

            mov     rax,1
            mov     rbx,1
            mov     rcx,[rbp-8]
            mov     rdx,5
            int     0x80
            push    rax

            mov     rdi,[rbp-8]
            call    free@PLT

            pop     rax
            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret

        pokerHand:#takes in pointer of length 5 struct card
            push    rbx
            push    rbp
            mov     rbp,rsp

            #printf
            #rdi takes FString
            #rsi takes string

            push    rdi     #-8
            call    _pokerHandFStringNL
            push    rax     #-16

            mov     rdi,5
            call    malloc@PLT
            push    rax     #-24
            mov     rdi,5
            call    malloc@PLT
            push    rax     #-32
            mov     rcx,[rbp-8]
            push    rdx
            xor     rdx,rdx
            xor     rbx,rbx
            _pokerHandL1:
                shl     rbx,8
                mov     bl,[rcx+rdx]
                add     rdx,2
                cmp     rdx,10
                jl      _pokerHandL1
            pop     rdx
            mov     rax,[rbp-24]
            push    rbx     #-40 Card Type
            mov     [rax],rbx

            mov     rax,[rbp-32]
            mov     rcx,[rbp-8]
            push    rdx
            xor     rdx,rdx
            xor     rbx,rbx
            inc     rdx
            _pokerHandL2:
                shl     rbx,8
                mov     bl,[rcx+rdx]
                add     rdx,2
                cmp     rdx,11
                jl      _pokerHandL2
            pop     rdx
            push    rbx     #-48 Card Suit
            mov     [rax],rbx

            
            mov     rdi,[rbp-40]
            mov     rsi,[rbp-48]
            call    _pokerHandCheck3OfKind
            cmp     rax,1
            jne     _pokerHandFWD
            call    _pokerHand3KindPrint

            _pokerHandFWD:

            mov     rdi,[rbp-16]
            mov     rsi,[rbp-24]
            xor     rax,rax
            call    printf@PLT

            mov     rdi,[rbp-16]
            mov     rsi,[rbp-32]
            xor     rax,rax
            call    printf@PLT

            mov     rdi,[rbp-24]
            call    free@PLT
            mov     rdi,[rbp-16]
            call    free@PLT
            mov     rdi,[rdi-32]
            call    free@PLT


            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret
            _pokerHand3KindPrint:
                push    rbx
                push    rbp
                mov     rbp,rsp

                call    _pokerHandTK
                push    rax     #-8
                call    _pokerHandFStringNL
                push    rax     #-16
                mov     rdi,[rbp-16]
                mov     rsi,[rbp-8]
                xor     rax,rax
                call    printf@PLT

                mov     rdi,[rbp-8]
                call    free@PLT
                mov     rdi,[rbp-16]
                call    free@PLT
                mov     rsp,rbp
                pop     rbp
                pop     rbx
                ret
        _pokerHandCheckHighCard:#rdi is type pointer, rsi is suit pointer, rax returns place of high card
            push    rbx
            push    rbp
            mov     rbp,rsp

            push    rdi     #-8
            push    rsi     #-16
            push    0       #-24 highest index
            xor     rcx,rcx
            _pokerHandCheckHighCardL1:
                mov     al,[rdi+rcx]
                #cmp     al,

            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret
        _pokerHandCheck3OfKind:#rdi is type pointer, rsi is suit pointer, rax returns 1 if 3 of kind
            push    rbx
            push    rbp
            mov     rbp,rsp

            push    rdi     #-8     type pointer
            push    rsi     #-16    suit pointer

            mov     rdi,5
            call    malloc@PLT
            push    rax     #-24
            mov     rax,rbp
            sub     rax,24
            xor     rbx,rbx
            xor     rcx,rcx
            xor     rdx,rdx
            _pokerHandCheck3OfKindL1:
                mov     rcx,rdx
                cmp     rcx,5
                jge     _pokerHandCheck3OfKindL1EQ5
                mov     bl,[rax+rdx]
                    _pokerHandCheck3OfKindL1L1:
                        mov     bh,[rax+rcx]
                        cmp     bl,bh
                        je      _pokerHandCheck3OfKindL1L1EQ
                        _pokerHandCheck3OfKindL1L1EQBack:
                        inc     rcx
                        cmp     rcx,5
                        jl      _pokerHandCheck3OfKindL1L1
                inc     rdx
                cmp     rdx,5
                jl      _pokerHandCheck3OfKindL1

            xor     rcx,rcx
            mov     rax,[rbp-24]

            _pokerHandCheck3OfKindL2:
                mov     bl,[rax+rcx]
                cmp     bl,2
                je      _pokerHandCheck3OfKindL23OfKind
                inc     rcx
                cmp     rcx,5
                jl      _pokerHandCheck3OfKindL2
            mov     rax,0
            _pokerHandCheck3OfKindEnd:
            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret
            _pokerHandCheck3OfKindL1L1EQ:
                push    rax
                push    rbx

                mov     rax,[rbp-24]
                mov     rbx,[rax+rdx]
                inc     rbx
                mov     [rax+rdx],rbx

                pop     rbx
                pop     rax
                jmp     _pokerHandCheck3OfKindL1L1EQBack
            _pokerHandCheck3OfKindL1EQ5:
                mov     bl,[rax+rdx]
                mov     rcx,4
                jmp     _pokerHandCheck3OfKindL1L1
            _pokerHandCheck3OfKindL23OfKind:
                mov     rax,1
                jmp     _pokerHandCheck3OfKindEnd
        _pokerHandFStringNL:
            mov     rdi,4
            call    malloc@PLT
            mov     rcx,0x0d0a7325    # %s\n
            mov     [rax],rcx
            ret
        _pokerHandFStringAppend:
            mov     rdi,2
            call    malloc@PLT
            mov     rcx,0x7325
            mov     [rax],rcx
            ret
        _pokerHandSF:
            mov     rdi,14
            call    malloc@PLT  # Straight Flush
            mov     rcx,0x676961727453
            mov     [rax],rcx
            mov     rcx,0x6873756c46207468
            mov     [rax+6],rcx
            ret
        _pokerHandTK:
            mov     rdi,15
            call    malloc@PLT  # Three of a Kind
            mov     rcx,0x666f206565726854
            mov     [rax],rcx
            mov     rcx,0x646e694b206120
            mov     [rax+8],rcx
            ret
        _pokerHandHC:
            mov     rdi,9
            call    malloc@PLT  # High Card
            mov     rcx,0x7261432068676948
            mov     [rax],rcx
            mov     rcx,0x64
            mov     [rax+8],rcx
            ret
        _pokerHandS:
            mov     rdi,8
            call    malloc@PLT  # Straight
            mov     rcx,0x7468676961727453
            mov     [rax],rcx
            ret
        _pokerHandFH:
            mov     rdi,10
            call    malloc@PLT  # Full House
            mov     rcx,0x756f48206c6c7546
            mov     [rax],rcx
            mov     rcx,0x6573
            mov     [rax+8],rcx
            ret
        _pokerHandTP:
            mov     rdi,8
            call    malloc@PLT  # Two Pair
            mov     rcx,0x72696150206f7754
            mov     [rax],rcx
            ret
        _pokerHandFK:
            mov     rdi,14
            call    malloc@PLT  # Four of a Kind
            mov     rcx,0x20666f2072756f46
            mov     [rax],rcx
            mov     rcx,0x646e694b2061
            mov     [rax+8],rcx
            ret
        _pokerHandOP:
            mov     rdi,8
            call    malloc@PLT  # One Pair
            mov     rcx,0x7269615020656e4f
            mov     [rax],rcx
            ret
        _pokerHandF:
            mov     rdi,5
            call    malloc@PLT  # Flush
            mov     rcx,0x6873756c46
            mov     [rax],rcx
            ret
        
        printfTest:
            push    rbx
            push    rbp
            mov     rbp,rsp

            mov     rdi,5
            call    malloc@PLT
            push    rax     #-8

            mov     rbx,0x74736554#"Test" backwards
            mov     [rax],rbx

            mov     rdi,5
            call    malloc@PLT
            push    rax    #-16

            mov     rbx,0x0d0a207325#"\n %s" backwards
            mov     [rax],rbx
            mov     rdi,rax
            mov     rsi,[rbp-8]
            xor     rax,rax
            call    printf@PLT#dont forget to zero rax

            mov     rdi,[rbp-16]
            call    free@PLT
            mov     rdi,[rbp-8]
            call    free@PLT
            

            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret

        writeChar: #rdi is char
            xor     rax,rax
            mov     cl,01
            int     0xe0
            ret

        setCursor: #rdi is x, rsi is y
            push    rbx
            mov     ah,2
            mov     bh,0
            mov     dh,0
            mov     dl,0
            int     0x10
            pop     rbx
            ret

        primeNumberFinder:
            push    rbx
            push    rbp
            mov     rbp,rsp
            cmp     rdi,2
            jle     _primeNumberFinderEndBad

            push    2   #Div number [-8]
            push    rdi #number to test [-16]
            
            _primeNumberFinderL1:
            mov     rax,[rbp-16]
            mov     rcx,[rbp-8]
            xor     rdx,rdx
            div     rcx
            cmp     rdx,0
            je      _primeNumberFinderNotPrime

            mov     rax,[rbp-8]
            inc     rax
            cmp     rax,[rbp-16]
            je      _primeNumberFinderFinished
            mov     [rbp-8],rax
            jmp     _primeNumberFinderL1

             _primeNumberFinderFinished:
                mov     rax,1
                jmp     _primeNumberFinderEnd
            _primeNumberFinderNotPrime:
                mov     rax,0
            _primeNumberFinderEnd:
            mov     rsp,rbp
            pop     rbp
            pop     rbx
            ret
            _primeNumberFinderEndBad:
                mov     rax,0
                jmp     _primeNumberFinderEnd


        whileLoopTest:
            push    rcx
            xor     rcx,rcx
            _whileLoopTestL1:
                inc     rcx
                cmp     rcx,rdi
                jle     _whileLoopTestL1
            pop rcx
            ret

        sysCallTest:
            ret

        sortHighestNumber:#rdi pointer,rsi length
            #rbx is preserved
            cmp     rsi,1
            jl      _sortHighestNumberBad

            push    rbx
            push    rbp
            mov     rbp,rsp
            xor     rcx,rcx #counter
            xor     rdx,rdx #current Index of highest
            push    rcx     #-8 index of highest in array
            mov     rax,[rdi+rdx*8]
            _sortHighestNumberL1:#largest number stored in rdx
                cmp     rax,[rdi+rcx*8]
                jl      _sortHighestNumberGreater
                _sortHighestNumberMain:
                inc     rcx
                cmp     rcx,rsi
                jl      _sortHighestNumberL1
                #rdx contains index of largest number in array
                #rax contains value of largest
                mov     rcx,[rbp-8]
                mov     rbx,[rdi+rcx*8]
                mov     [rdi+rcx*8],rax
                mov     [rdi+rdx*8],rbx
                #swapped
                #rbx contains what was in index rcx
                inc     rcx
                cmp     rcx,rsi
                jge     _sortHighestNumberL1End
                mov     [rbp-8],rcx
                #save rcx
                mov     rdx,rcx
                mov     rax,[rdi+rdx*8]


                jmp     _sortHighestNumberL1

                _sortHighestNumberGreater:
                    mov     rdx,rcx
                    mov     rax,[rdi+rdx*8]
                    jmp     _sortHighestNumberMain
                _sortHighestNumberL1End:


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
