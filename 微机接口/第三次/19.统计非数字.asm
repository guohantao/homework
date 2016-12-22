data segment  
    s1  db 'please input the string : $'   
    s2  db 'the result is: $'
    buf db 100,99 dup(0)
    num dw 0 
    N   db 10 dup(0)
    
data ends

code segment
    assume cs:code, ds:data
    start:
        mov ax,data
        mov ds,ax 
        
        mov dx,offset s1
        mov ah,09h
        int 21h
        
        mov dx,offset buf
        mov ah,0ah
        int 21h
        
        lea bx,[buf+2]
        mov cx,0
        mov cl,[buf+1]
        
        loop1:
            mov al,[bx] 
            cmp al,'$'
            je  finish
            cmp al,'0'
            jb  count
            cmp al,'9'
            ja  count
            jmp next
        
        count:
            inc num
            jmp next  
            
        
        next:
            inc bx
            loop loop1  
            
        finish:  
            
            mov dl,0ah  ;回车换行显示
            mov ah,02h
            int 21h 
            mov dl,0dh
            mov ah,02h
            int 21h 
            mov dx,offset s2
            mov ah,09h
            int 21h
            
            ;转换成十进制 
           
            mov bx,offset N
            mov ax,num  
          loop2:
            mov cl,10
            div cl   
            
            mov [bx],ah    ;将余数存到n数组中
            inc bx 
            mov ah,0
            
            cmp al,0
            je  output
            jmp loop2
            
         
          output:
            dec bx   
            mov dl,[bx]
            add dl,'0'
            mov ah,02h
            int 21h
            cmp bx,offset N
            ja output
            
            mov ax,4c00h
            int 21h
            
             
        
code ends
end start
        
       