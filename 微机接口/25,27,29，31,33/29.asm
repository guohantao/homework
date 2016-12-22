data segment
    array dw 00ffh,55aah,55aah
data ends

code segment
    assume:cs:code,ds:data
    start:
      mov ax,data
      mov ds,ax
      
      mov bx,offset array
      
      mov ax,[bx]
      
      ;�Ƚ�1,2
      cmp ax,[bx+2]   
      je  now_two_equal   ; ���������������
      jmp now_no_equal     ;  ����û�������
      
      ;1,2��ȱȽ�1,3
      now_two_equal:
        cmp ax,[bx+4]
        je finish_three_equal  ;�������
        jmp finish_two_equal   ;ֻ��1��2���
      
      ;1,2���� �Ƚ�1,3
      now_no_equal:
        cmp ax,[bx+4]
        je finish_two_equal    ;1,3���
        jmp now_judge_2_3_equal;�ж�2,3�Ƿ����
        
      ;1,2����ȣ��ж�2,3�Ƿ����  
      now_judge_2_3_equal:
        mov ax,[bx+2]
        cmp ax,[bx+4]
        je finish_two_equal
        jmp finish_no_equal
       
        
        
      finish_three_equal:
        mov dl,'2'
        mov ah,02h
        int 21h
        jmp finish
      
      finish_two_equal:
        mov dl,'1' 
        mov ah,02h
        int 21h 
        jmp finish
        
        
      finish_no_equal:
        mov dl,'0' 
        mov ah,02h
        int 21h  
        
      finish:
       mov ah,4ch
       int 21h
code ends
end start