data segment
    buf db 20,4,'00000' 
    wrong db 17,'wrong,try again',0ah,0dh,'$'
data ends
stack segment
    st db 50dup(0)
stack ends
code segment
    assume:cs:code  ds:data ss:stack
    start:          
        mov ax,data
        mov ds,ax
        
  again:mov dx,offset buf  ;��������buf��
        mov ah,0ah
        int 21h 
        mov bx,offset [buf+2] ;ָ�� 
        mov cx,4 
        
        mov dl,0ah  ;�س�������ʾ
        mov ah,02h
        int 21h 
        mov dl,0dh
        mov ah,02h
        int 21h 
        
  loop1:mov al,[bx]     ;��һ���ַ� 
        cmp al,'0'
        jb  stop       ;��������ַ�
        cmp al,'9' 
        jbe num
         
         
        cmp al,'a'
        jb  stop
        cmp al,'f'
        jbe word
        jmp stop        ;��������ַ�
        
        num: sub al,'0'
             jmp output
             
        
        word:sub al,'a'
             add al,10
             jmp output
          
     output:
            push cx;
            mov  cx,4 
            mov  dh,08h   ;���԰�λ���
     loop2: test al,dh
            jz  out0    ;���0  
            push ax
            mov dl,'1'  ;���1
            mov ah,02h
            int 21h
            pop ax 
            
     label1:shr dh,1
            loop loop2 
            pop cx      ;�ָ�CX��ȡ��һ��ʮ�������� 
            inc bx      ;ָ���1 
            mov dl,' '  ;��ӡ�ո�
            mov ah,02h
            int 21h
            loop loop1
            jmp finish  ;ִ�н���
            
        ;���0����Ļ��    
       out0: push ax
            mov dl,'0'
            mov ah,02h
            int 21h 
            pop ax
            jmp label1
            
       stop:mov ah,09h
            mov dx,offset wrong 
            int 21h   
            
            jmp again
       
       finish:
              mov ax,4c00h
              int 21h 
        
                
                
code ends
end start