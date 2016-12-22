code_seg segment
    assume cs:code_seg
    start:
        mov ah,01h
        int 21h
        sub al,'0'
        jb  stop
        cmp al,9
        ja  stop
        cbw
        mov cx,ax
        jcxz stop  ;判断循环数是否为0
        
        bell:
            mov dl,07h
            mov ah,02h    
            int 21h  
            loop bell
        
        jmp start  
           
        stop:ret 
code_seg  ends
 end start