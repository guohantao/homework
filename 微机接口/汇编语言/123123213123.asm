student struc 
    xname   db 'null'
    xclass  db 'null'
    xnumber db 'null'
    xgrade  db 'null'
student ends
      
DATAS SEGMENT
    ;�˴��������ݶδ���  
DATAS ENDS

STACKS SEGMENT
    ;�˴������ջ�δ���
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;�˴��������δ���
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
