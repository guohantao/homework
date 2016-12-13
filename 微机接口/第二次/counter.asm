data_seg segment
    buff    dw 200 dup(0)
    n1      dw 0    ;正数
    n2      dw 0    ;0
    n3      dw 0    ;负数
data_seg ends

code_seg segment
    assume cs:code_segment,ds:data_segment
    start:
        mov ax,data_seg
        mov ds,ax  
        mov cx,200   
        mov bx,0
        loop1:  cmp  buff[bx],0
              jge  biggerorequal  ;大于等于0
              add  n3,1 
              add  bx,2 
              jmp  next 
              
              
        biggerorequal: 
              cmp   buff[bx],1    ;是否是0
              jge   bigger 
              add   n2,1
              add   bx,2 
              jmp   next
               
              
         bigger:
              add   n1,1;   正数
              add   bx,2
              jmp   next
              
         next: loop loop1
              ;
              mov ax,4c00h
              int 21h;
        
        
    code_seg ends
        end start