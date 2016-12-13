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
        
  again:mov dx,offset buf  ;将数输在buf中
        mov ah,0ah
        int 21h 
        mov bx,offset [buf+2] ;指针 
        mov cx,4 
        
        mov dl,0ah  ;回车换行显示
        mov ah,02h
        int 21h 
        mov dl,0dh
        mov ah,02h
        int 21h 
        
  loop1:mov al,[bx]     ;第一个字符 
        cmp al,'0'
        jb  stop       ;输入错误字符
        cmp al,'9' 
        jbe num
         
         
        cmp al,'a'
        jb  stop
        cmp al,'f'
        jbe word
        jmp stop        ;输入错误字符
        
        num: sub al,'0'
             jmp output
             
        
        word:sub al,'a'
             add al,10
             jmp output
          
     output:
            push cx;
            mov  cx,4 
            mov  dh,08h   ;测试按位输出
     loop2: test al,dh
            jz  out0    ;输出0  
            push ax
            mov dl,'1'  ;输出1
            mov ah,02h
            int 21h
            pop ax 
            
     label1:shr dh,1
            loop loop2 
            pop cx      ;恢复CX，取下一个十六进制数 
            inc bx      ;指针加1 
            mov dl,' '  ;打印空格
            mov ah,02h
            int 21h
            loop loop1
            jmp finish  ;执行结束
            
        ;输出0到屏幕上    
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