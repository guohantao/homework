data segment 
    A db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    B db 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39
   
    C db 15 dup(0)
data ends

stack segment
    db 50 dup(0)
stack ends 

code segment
    assume: cs:code,ds:data,ss:stack
    start:
        mov ax,data
        mov ds,ax  
        
        mov cx,15
        mov bx,offset a
        mov bp,offset c  ;段超越，用bp间接寻址
      loop_a:
        mov al,[bx]
        push bx  
        push cx
        mov bx,offset b 
        mov cx,20  
      loop_b: 
        mov ah,[bx]
        cmp ah,al
        jne next_b
        
        mov ds:[bp],ah
        inc bp
        jmp next_a
        
       next_b:
            inc bx
            loop  loop_b 
            
      next_a:
        pop cx
        pop bx
        inc bx
        loop loop_a
     
     mov ah,4ch
     int 21h
        
code ends
end start
        
        
        
        
        