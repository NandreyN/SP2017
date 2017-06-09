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

.data
    szHelloWorld        db  "Hello, world!", 13, 10,
                            "Press ENTER to continue...", 13, 10, 0
    buf                 db  300 dup(0)
    x                   dq 3.16
    a                   dq 0.5
.code

MainProc	proc
            finit
            fld x;ST(0)=x
            fld a;
            fyl2x
            fld st(0); 
            frndint; ST(0) 
            fxch st(1); ST(0) ? ST(1)
            fsub st(0), st(1);st(0)=y-round(y)
            f2xm1; ST(0)=2^ST(0)-1=2^(y-round(y))-1
            fld1; ST(0)=1, (ST(1)=2^(y-round(y))-1, ST(2)=round(y)
            fadd st(1), st(0);ST(1)=2^(y-round(y))
            fxch st(2);ST(0)=round(y), ST(2)=1
            fxch st(1);ST(0)=2^(y-round(y)), ST(1)=round(y)
            fscale;ST(0)=ST(0)*2^(ST(1))=2^(y-round(y)+round(y))=2^y
            fstp x
                
            invoke  FloatToStr, x, addr buf
            invoke  StdOut, addr buf
            invoke  StdIn, addr buf, 300
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
