code_seg segment
    assume cs:code_seg
    
    start:     
    ;注意输入法的使用，使用中文输入法会导致错误
         mov ah,01h
         int 21h  
          
         cmp al,'a'
         jb  stop
         cmp al,'z'
         ja  stop 
         sub al,20h
         mov dl,al
         mov ah,02h  
         int 21h  
         mov dl,0ah  ;换行
         mov ah,02h
         int 21h     ;回车
         mov dl,0dh
         mov ah,02h
         int 21h
         jmp start
         
         
         stop: 
         mov ax,4c00h
         int 21h
     code_seg ends
end start
         