data_seg segment
    array dw 23,36,2,100,32000,54,0
    zero  dw 1
data_seg ends        

code_seg segment
    ;main porce near
    assume: cs:code_seg, ds:data_seg   
start:    
       
    mov ax,data_seg
    mov ds,ax
    mov bx,offset [array];  
    mov ax , [bx+12] ;内存不能到内存
    mov zero,ax
    
    mov ax,4c00H
    int 21 
code_seg ends
   end start