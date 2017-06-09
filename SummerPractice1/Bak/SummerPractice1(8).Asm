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
    maxLen              dd 255
    latinCharset        db "qwertyuioplkjhgfdsazxcvbnm"
    latinVowels         db "eyioau"
.data
    strOnlyEng          db  "Only Latin : ",0
    eqcnt               db  "  eq count: ", 0
    szHelloWorld        db  "Input string : ", 13, 10,0
    buf                 db  255 dup(0); was ' '
    resstr              DB 16 dup (?) 
    bufLen              dd 0
    onlyLat             dd 0
    eqCount             dd 0
    vowels              dd 0
    subLen              dd 0
.code
;3.	Строка состоит из слов, разделенных одним или несколькими пробелами. Найти количество слов, 
;содержащих только символы латинского алфавита, а среди них - количество слов с равным числом гласных и согласных букв. 



HandleWord proc
;  Function will process word in terms of determing whether it contains non-Latin symbols or not
;  and define if the word contains the same amount of vowels and consonants   
    push ecx
    
    mov ebx, [esp + 8]; start
    mov esi, [esp + 12]; end
    xor edx ,edx ; subindex
    mov vowels, 0
    
    mov ecx, esi
    sub ecx, ebx; sublength
    mov subLen , ecx
    
    check_all:
        lea edi, latinCharset
        mov ecx , 26d
        mov al, buf[ebx + edx]
        repne scasb
        jecxz wrong_symbol
        
    inc edx
    cmp edx, subLen
    jl check_all
    inc onlyLat
    
    xor edx, edx
    check_sep:
        mov al, buf[ebx + edx]
        lea edi , latinVowels
        mov ecx, 6
        repne scasb 
        jecxz next_symbol
        inc vowels
    next_symbol:    
    inc edx
    cmp edx, subLen
    jl check_sep
    
    mov eax, vowels
    shl eax ,1
    cmp eax, subLen
    jne wrong_symbol
    inc eqCount
    wrong_symbol:
    pop ecx
    ret 8
HandleWord endp

MainProc	proc
            invoke  StdOut, addr szHelloWorld
            invoke  StdIn, addr buf, 300
            ; now string is in buff array
            ; 65-90 , 97-122
            xor edx, edx; previous start index of substring
            push esi
            push edi
            
            xor esi, esi; current start index of the substring 
            
            mov ecx, maxLen
            lea edi , buf
            mov al, 0
            repne scasb 
            
            mov eax, maxLen
            sub eax, ecx
            sub eax , 3
            mov bufLen , eax; string legnth in bufLen variable
            mov ecx, eax
            
            lea edi, buf
            tolower:
                mov bl, buf[ecx]
                cmp bl, 65
                jl dont_change
                cmp bl, 90
                jg dont_change
                ; change 
                or buf[ecx], 20h
                dont_change:
            loop tolower
             
            mov ecx, bufLen
            ; find a separate word
            lea edi, buf; refresh string head pointer
            
            ; esi - curr
            ; edx - prev
            word_search: 
                mov al ,' '; symbol to search
                mov edx, esi
                cld
                repne scasb
                mov eax, bufLen
                sub eax, ecx
                dec eax
                mov esi, eax
                
                push esi
                push edx
                call HandleWord
                
                mov al, ' '
                cld 
                repe scasb
                mov eax, bufLen
                sub eax, ecx
                dec eax
                mov esi, eax
                
            cmp ecx , 0
            jg word_search
            
            invoke StdOut, addr strOnlyEng
             mov eax, onlyLat
            invoke dwtoa, eax, addr resstr
            invoke StdOut, addr resstr
            
            
            invoke StdOut, addr eqcnt
            mov eax, eqCount
            invoke dwtoa, eax, addr resstr
            invoke StdOut, addr resstr
            invoke  StdOut, addr buf
            invoke  StdIn, addr buf, 300
            
            pop edi
            pop esi
            invoke  ExitProcess, 0
MainProc    endp

end MainProc
