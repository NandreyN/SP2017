.486
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
;ax^2 + b/(x-b) + c = 0
; [-a b]

.const 
    n                   dd 4000
    zero                dq 0.0
.data
    buf                 db  300 dup(0)
    newLine             db  13,10,0
    left                dq -2.0
    right               dq  6.0
    fxleft              dq  ?
    fxrigth             dq  ?
    junk                dq ?
    
    a                   dq  2.0
    b                   dq  6.0
    cc                  dq  -2.0
    x                   dq  -1.4
    fx                  dq  ?
    i                   dd  0
    h                   dq  ?
.code

func proc
    fld x
    fld b
    fsub
    fld b
    fxch st(1)
    fdiv
    
    fld x
    fld x
    fmul
    fld a
    fmul
    fadd
    fld cc
    fadd
    
    fstp fx
    ret
func endp

;ax^2+b/(x-b)+c=0                                 
; [-a, b]



MainProc	proc
            
            finit
            ; h
            fild n
            fld right
            fld left
            fsub
            fdiv st(0), st(1)
            fstp h
            fstp junk
            
            mov i, 0
            mov ecx, n
            cycle:
            ; calc first
            fild i
            fld h
            fmul
            fld left 
            fadd
            fst x; left
            fstp left
            
            call func
            
            fld fx
            fstp fxleft
            
            inc i
            fild i
            fld h
            fmul
            fld left 
            fadd
            fst x; left
            fstp right
            call func
            
            fld fx
            fstp fxrigth
            
            fld fxleft
            fld fxrigth
            fmul st(0), st(1) 
            ; ja
            fcom zero 
            fstp junk
            fstp junk
            
            FSTSW AX
            SAHF
            ja skip
            
            invoke FloatToStr, left, addr buf
            invoke StdOut, addr buf
            
            invoke StdOut , addr newLine
            
            invoke FloatToStr, right, addr buf
            invoke StdOut, addr buf
            
            invoke StdOut , addr newLine
            skip:
            dec ecx
            cmp ecx, 0
            jg cycle
            
            invoke  StdIn, addr buf, 300
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
