data segment
    n equ 10 
    address dw ? ;存放绝对值最大的数的地址      
    m dw -1,2,3,4,-5,-3,0,0,0,0 
    x equ 2*n
data ends   
stack segment
    st db 100 dup(0)
stack ends
code segment
    assume:cs:code, ds:data, ss:stack
    start:  
    mov ax,data
    mov ds,ax
    
    mov bx,offset m
    mov cl,n
    mov dx,0
    
    loop1:
        mov ax,[bx]
        cmp ax,0
        jl  minus ;负数
        cmp dx,ax
        jl  max    ;最大值小与当前值
        jmp next
        
        
    minus:
        neg ax
        cmp dx,ax
        jl  max ;al 大于 dl   
        jmp next
        
            
     max:
        mov dx,ax
        mov address,bx
        jmp next
        
           
     next: 
        add bx,2
        loop loop1
        
     mov bx,address
     mov ax,[bx]            ;取绝对值最大的数
     mov bx,offset m
     mov [bx+x],ax          ;把绝对值最大的数 放在m+2n  
      
     mov ax,address         ;取最大数的地址
     mov [bx+x+2],ax
     
     mov ax,4c00h
     int 21h
     
    
    
    
code ends
end start