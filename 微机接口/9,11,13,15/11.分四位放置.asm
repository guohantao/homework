
code_seg segment
    assume cs:code_seg,ds:dataseg
    start:  
        
        mov ax,1234h  ;
        push ax
        mov  cl,4 
        
        shr ax,cl   ;将4-7位放置BL
        mov bl,al
        and bl,0fh   
        
        shr ax,cl   ;将12-15放置DL
        mov dl,al
        and dl,0f0h    
        shr dl,cl
        
        
        mov cl,al     ;将8-11位放置CL
        and cl,0fh
        
        pop ax        ;将0-3位放置AL
        and al,0fh  
        mov ah,0
        
code_seg ends
end start
    