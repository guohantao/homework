data segment
    string db 99 dup('a') ,  '1'
data ends

code segment
    assume: cs:code,ds:data
    start: 
        mov ax,data
        mov ds,ax 
        
        mov cx,100
        mov bx,offset string
        
        loop1:
            mov al,[bx]
            cmp al,'0'
            jb next
            cmp al,'9'
            ja next
            jmp setcl
            
        next:    
            inc bx
            loop loop1
            jmp   finish
            
        setcl:
            or cl,10h   
        finish:
            mov ax,4c00h
            int 21h
        
        
    
code ends
end start