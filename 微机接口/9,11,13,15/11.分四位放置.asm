
code_seg segment
    assume cs:code_seg,ds:dataseg
    start:  
        
        mov ax,1234h  ;
        push ax
        mov  cl,4 
        
        shr ax,cl   ;��4-7λ����BL
        mov bl,al
        and bl,0fh   
        
        shr ax,cl   ;��12-15����DL
        mov dl,al
        and dl,0f0h    
        shr dl,cl
        
        
        mov cl,al     ;��8-11λ����CL
        and cl,0fh
        
        pop ax        ;��0-3λ����AL
        and al,0fh  
        mov ah,0
        
code_seg ends
end start
    