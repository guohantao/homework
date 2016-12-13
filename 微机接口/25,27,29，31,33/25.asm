 data segment
    mem db 4 dup(0)
 data ends
 code segment 
   assume: cs:code,ds:data
   start: 
    mov ax,data
    mov ds,ax
    
    mov ax,2a48h 
   
    mov bx, offset mem
    mov cx,4
    lp1:
    push ax
      and ax,000fh  
      push cx 
        mov cx,11
        div cl 
      pop cx 
      cmp ah,9
      ja word
      add ah,'0' 
      jmp store
      word:
       sub ah,10
       add ah,'A'
      store:
      mov [bx],ah
      inc bx
    pop ax 
    push cx
     mov cx,4
     ror ax,cl 
    pop cx
    loop lp1
      
      
          
          
 code ends
 end start