code_seg segment
    assume cs:code_seg
    
    start:     
    ;ע�����뷨��ʹ�ã�ʹ���������뷨�ᵼ�´���
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
         mov dl,0ah  ;����
         mov ah,02h
         int 21h     ;�س�
         mov dl,0dh
         mov ah,02h
         int 21h
         jmp start
         
         
         stop: 
         mov ax,4c00h
         int 21h
     code_seg ends
end start
         