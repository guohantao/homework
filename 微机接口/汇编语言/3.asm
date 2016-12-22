data_seg segment
    PARTNO	DW		?
    PNAME	DB		16 DUP (0)
    COUNT	DD		?
    PLENTH	EQU	$-PARTNO
data_seg ends        

code_seg segment
    ;main porce near
    assume: cs:code_seg, ds:data_seg   
start:    
       
    mov ax,data_seg
    mov ds,ax
    mov ax,plenth
    
    mov ax,4c00H
    int 21 
code_seg ends
   end start