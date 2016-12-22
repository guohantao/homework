data_seg segment
    data dw 1,2,3,4,5,6,7,8,9,10,90 dup(5)
    min  dw -1 
    even db 2
data_seg ends
code segment
    assume cs:code,ds:data_seg
    start:
        mov ax,data_seg
        mov ds,ax
        mov dx,0ffffh
        mov bx,0  
        mov cx,100 
        

        
        loop1:     
            mov ax,data[bx] 
            div even
            cmp ah,0
            je compare 
            jmp next 
       
        compare:  
            cmp data[bx],dx
            jb  m  
            jmp next
            
        m:   mov dx,data[bx] 
             jmp next
             
        next: 
            add bx,2
            loop loop1
        
        mov min,dx
        
code ends
end start