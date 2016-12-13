FINSUM MACRO X,Y  
    LOCAL  LOP1 
    
    MOV AX,X
    MOV BX,Y
    CMP AX,BX ;不能是 内存和内存
    JG  LOP1  
    MOV BL,2
    MUL BL
    MOV SUM,AX+Y
   ; MOV SUM, 2X+Y
    JMP NEXT  
    
    LOP1：
        MOV BL,2   
        MOV AX,Y
        MUL BL
        MOV SUM,X+AX
        JMP NEXT
    NEXT:
    
    
ENDM
                    


DATA_SEG SEGMENT
    SUM DW ? 
    X   DW ?
    Y   DW ?
DATA_SEG ENDS  

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    START:           
        MOV AX,DATA_SEG
        MOV DS,AX
        FINSUM X,Y
      
        MOV AX,4C00H
        INT 21H
    
    
    CODE_SEG ENDS
END START