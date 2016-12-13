data_seg segment
    BUFF	DB   1, 2, 3, '123'
    EBUFF	DB   0
    L		EQU  EBUFF - BUFF
data_seg ends        

code_seg segment
    ;main porce near
    assume: cs:code_seg, ds:data_seg   
start:    
       
    mov ax,data_seg
    mov ds,ax
    mov ax,l
    
    mov ax,4c00H
    int 21 
code_seg ends
   end start