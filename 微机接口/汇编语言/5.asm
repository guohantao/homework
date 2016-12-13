data_seg segment
    LNAME		DB  30 DUP (0)
    ADDRESS	    DB  30 DUP (0)
    CITY		DB  15 DUP (0)
    CODE_LIST	DB  1, 7, 8, 3, 2
data_seg ends        

code_seg segment
    
    assume: cs:code_seg, ds:data_seg   
start:    
       
    mov ax,data_seg
    mov ds,ax
    mov ax, offset lname
    mov si,word ptr code_list
    code_length  equ $-code_length
    
    mov ax,4c00H
    int 21 
code_seg ends
   end start