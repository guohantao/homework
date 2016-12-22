data segment
    a dw 11
    b dw 5
data ends

code segment
    assume: cs:code,ds:data
    start:   
        mov ax,data
        mov ds,ax
        
        mov cl,2
        mov ax,a
        div cl
        cmp ah,0  ;a除以2余数是否为0
        je  a_even
        jmp a_odd 
        
     a_even:
        mov ax,b
        div cl 
        cmp ah,0
        je a_b_even
        jmp a_even_b_odd 
        
        
     a_odd:
        mov ax,b
        div cl 
        cmp ah,0
        je a_odd_b_even
        jmp a_b_odd
        
     a_b_even:
        jmp finish
        
     a_b_odd:
        inc a
        inc b
        jmp finish
        
     a_even_b_odd: 
        mov ax,a
        xchg ax,b
        mov a,ax
        jmp finish
        
     a_odd_b_even:
     finish:
      mov ah,4ch
      int 21h
    
code ends
end start