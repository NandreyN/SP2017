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

.const 
    n                   dd 20
    oneHalf             dq 0.5
.data
    i                   dd 0
    x                   dq 0.0
    h                   dq ?
    fx                  dq ?
    
    buf                 db  300 dup(0)
    additionalvar       dq 0.0
    junk                dq 0.0
    halfsum             dq 0.0
    sum                 dq 0.0
.code

func proc
    fld x
    fld x
    fmul
    fsin
    mov dword ptr [additionalvar], 5d
    fild additionalvar
    fld x
    fmul 
    fadd
    fstp fx    
    ret
func endp

MainProc	proc
            
            ;calculate h = (b - a )/n
            finit
            
            fild n
            fldpi
            fldpi
            fadd
            fdiv ST(0), ST(1) 
            fstp h
            
            mov ecx, n
            dec ecx
            mov i,1
            
            lin_sum:
                fild i;i
                fld h
                fmul
                fstp x; xi
                
                call func
                fld fx
                fld sum
                fadd
                fstp sum
                
                inc i
            loop lin_sum
            
            ; half-sum
            fldz
            fstp x
            
            call func 
            fld halfsum
            fld fx
            fadd
            fstp halfsum
            
            fldpi 
            fldpi
            fadd
            fstp x
            
            call func 
             fld halfsum
            fld fx
            fadd
            fstp halfsum
            
            fld halfsum
            fld oneHalf
            fmul
            fstp halfsum

            fld sum
            fld halfsum
            fadd
            fstp sum
            fstp junk
            
            fld sum
            fld h
            fmul
            fstp sum
            fstp junk
             
            invoke FloatToStr, sum, addr buf 
            invoke StdOut, addr buf
            
            invoke  StdIn, addr buf, 300
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
