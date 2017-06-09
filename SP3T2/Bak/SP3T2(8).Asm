.586
.model flat, stdcall                    
option casemap :none

include windows.inc     ; always first

include masm32.inc
include gdi32.inc
include user32.inc
include kernel32.inc

includelib masm32.lib
includelib gdi32.lib
includelib user32.lib
includelib kernel32.lib

.const 
    x                   dq 1.0
    n                   dd 20
    minusOne            dq -1.0
.data
    szHelloWorld        db  "Hello, world!", 13, 10,
                            "Press ENTER to continue...", 13, 10, 0
    buf                 db  300 dup(0)
    member              dq ?
    sum                 dq ?
    k                   dd 1
    exp                 dq ?
    division            dq ?
    junk                dq ?
.code

MainProc	proc
            finit 
            
            mov ecx,n
            mov k,1
            cycle:
            ; exp
            fld k
            fld x
            fdiv st(0), st(1)
            fstp division
            fstp junk
            
            push ecx
            mov ecx, k
            ;dec ecx
            fld minusOne
            fld x
            min_one:
                fmul st(0), st(1)
            loop min_one
            pop ecx
            fld division
            fmul st(0), st(1)
            fld sum
            fadd 
            fstp sum
            
            fstp junk
            fstp junk
            fstp junk
            fstp junk
            
            inc k
            loop cycle           
           
            invoke FloatToStr, qword ptr sum , addr buf
            invoke  StdOut, addr buf
            
            invoke StdIn, addr buf, 300
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
