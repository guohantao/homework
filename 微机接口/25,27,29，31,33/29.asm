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
      
      ;比较1,2
      cmp ax,[bx+2]   
      je  now_two_equal   ; 现在有两个数相等
      jmp now_no_equal     ;  现在没有数相等
      
      ;1,2相等比较1,3
      now_two_equal:
        cmp ax,[bx+4]
        je finish_three_equal  ;三个相等
        jmp finish_two_equal   ;只有1，2相等
      
      ;1,2不等 比较1,3
      now_no_equal:
        cmp ax,[bx+4]
        je finish_two_equal    ;1,3相等
        jmp now_judge_2_3_equal;判断2,3是否相等
        
      ;1,2不相等，判断2,3是否相等  
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