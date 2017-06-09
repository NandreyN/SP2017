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
    inpMsg db "Input dimension :", 13,10,0
    inputBuffer BYTE 10 dup(' ')
    buf                 BYTE    0,1,2,3,4,
                                4,0,7,7,1,
                                1,2,0,0,6,
                                5,2,4,1,0,
                                0,7,8,9,2
    dim dd 0
    res dd 1
.code
;3.	¬ квадратной матрице размера nxn (n-байт) 
;из целых беззнаковых чисел длиной в байт проверить, 
;содержит ли кажда€ строка и столбец ровно один ноль;
MainProc	proc
            
            
            invoke StdOut, addr inpMsg
            invoke StdIn, addr inputBuffer, LengthOf inputBuffer
            invoke StripLF, addr inputBuffer
            invoke atol, addr inputBuffer; result in eax
            mov dim ,eax
            
            push esi; i
            push edi; j
            xor esi, esi
            xor edi, edi
            
            str_c:
                xor ebx ,ebx; zero counter
                xor edi, edi
                col_c:
                ; calc
                mov eax , dim
                mul esi
                add eax , edi
                
                cmp buf[eax],0
                jne not_zero
                inc ebx
                
                not_zero:
                inc edi
                cmp edi, dim
                jl col_c
                
                cmp ebx , 1
                jne no
                
                inc esi
            cmp esi , dim
            jl str_c
            
            xor esi, esi;i
            xor edi ,edi;j
            
            
            columns:
                xor ebx, ebx
                xor esi, esi
                rows:
                
                mov eax , dim
                mul esi
                add eax , edi
                cmp buf[eax],0
                jne nz
                inc ebx
                nz:
                inc esi
                cmp esi , dim
                jl rows
                
                cmp ebx ,1
                jne no 
            inc edi
            cmp edi ,dim
            jl columns
            
           
            
            no:
            mov res,0
            finish:
            pop edi
            pop esi
            invoke dwtoa, res, addr inputBuffer
            invoke StdOut, addr inputBuffer
            invoke StdIn, addr inputBuffer, LengthOf inputBuffer
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
