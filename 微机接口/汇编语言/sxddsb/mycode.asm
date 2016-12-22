
;student struc 
;    xname   db 10db
;    xclass  db 10db
;    xnumber db 10db
;    xgrade  db 2db  ;�Զ����������棬����*10����������ʾС��
;student ends


data segment  
    cr equ 0dh��0ah ;�س�+���� 
    tab equ 9 ;tab         
    
    
    
    str1 db 'please input the function you want to��',cr,'1. add grade  2.sort  3.get average 4.get the number of each rank',cr,'$'
    str2 db cr,'please the sort way�� 1.by number  2.by grade',cr,'$'
    str3 db cr,'please the student: name , class , number , grade,divid by /,end by # ',cr,'(name, class, number size should smaller than 10 db and not permit space)',cr,'$'
    str4 db cr,'input wrong,try again',cr,'$' 
    
    
    in_buf db 50,0,50 dup(0)  ;���뻺��buf  in_buf[2]����������Ŀ�ʼ
            
    
     
    num  dw 0   ; ѧ������ 
      
               ;����       �༶         ѧ��         �ɼ�    �س�����
    student db 10 dup(' '),10 dup(' '),10 dup(' '), 2 dup(0),  cr
    
    buf db   20*student_db dup(0)    ;20��ѧ����buf 
    student_db equ 34  ;һ��ѧ��ռ32db,���лس�ռ2db
    xname equ 0  ;��һ��ѧ���ṹ����ƫ����Ϊ0 
    xclass equ 10  ;��һ��ѧ���ṹ����ƫ����Ϊ10  
    xnumber equ 20  ;��һ��ѧ���ṹ����ƫ����Ϊ20
    xgrade equ 30  ;��һ��ѧ���ṹ����ƫ����Ϊ30 
    buf_end dw 0 ;�洢bufβ���ĵ�ַ
    
    flag db 0  ;copystr�����У�������λ�����ı��
data ends   

stack segment
    db 100 dup(0)
stack ends

code segment
    assume: cs:code,ds:data,ss:stack ,es:data
    proc near
    start:
         mov ax,data
         mov ds,ax 
         mov es,ax 
         mov buf_end,offset buf
    begin: 
         mov dx,offset str1
         call print
         call gets  
         
         mov dl,in_buf[2]
         cmp dl,'1'
         je add_grade
         cmp dl,2
         je sort
         cmp dl,3
         je average
         cmp dl,4
         je get_num_rank 
         
         ;����������� 
      wrong:
         mov dx,offset str4
         call print
         jmp begin  
         
         
         
;---------------------------------------------��ӳɼ�----------------------------------------------
        add_grade: 
            mov dx,offset str3
            call print
            call gets 
            call copystr ;��in_buf�е����ݿ����� student��ʽ��
            ;��student������buf��
            mov si,offset student
            mov di,buf_end
            mov cx,student_db
            cld
            rep movsb
            
            add  buf_end,student_db
            inc num ;ѧ������+1  
            call flush_in_buf_and_student ;!!!!!!!!!!!���student �� buf
            
;---------------------------------------------����-------------------------------------------------
        sort: 
            mov bx,offset buf
            
;---------------------------------------------��ƽ��-----------------------------------------------
        average:
           call get_average
            
;--------------------------------------------��������ͳ��--------------------------------------------
        get_num_rank:
         
        mov ax,4c00h
        int 21h   
        
        
        
        
        
        
;--------------------------------------------��ӡ����------------------------------
print proc near
      mov ah,09h
      int 21h
      ret
print endp  

;-------------------------------------------��ȡ���뺯�����ַ���---------------------------------
gets proc near
    mov ah,0ah  
    mov dx,offset in_buf
    int 21h 
    
    ret
gets endp   

;--------------------------------------------�ַ�����������,��in_buf ���涨��student��ʽ������student��-----------------------------------
copystr proc
    push si
    push di
    
    mov si,offset in_buf +2 ;in_buf[2]����������Ŀ�ʼ
    lea di,student
    cld ;��������ʽ����
   lp_copy:
    cmp [si],'/'
    je  judge_offset
    movsb ;si,di�Զ���1
    jmp lp_copy
    
    judge_offset:
       cmp flag,0
       je offset_class    ;��DI��ָ���Ƶ���class����ʼ
       cmp flag,1
       je offset_num      ;��DI��ָ���Ƶ���number����ʼ
       cmp flag,2
       je finish_copy     ;��DI��ָ���Ƶ���grade����ʼ
       
    offset_class:
        mov di,offset student + xclass 
        inc si
        inc flag
        jmp lp_copy
    offset_num:
        mov di,offset student +xnumber 
        inc si 
        inc flag
        jmp lp_copy
             
    finish_copy:
        mov di,offset student +xgrade 
        inc si 
        mov flag,0 
    call dec_to_bin  
      
    pop di
    pop si
    ret
copystr endp   
;--------------------------------------------��Ļ�е�10����ת4λ2������-------------------------------------
dec_to_bin proc
    push cx
    push ax
    push dx
    push si 
    push bx
    
    mov ax,0
    mov dx,0
    mov cx,10
  lp_dec_to_bin:   
    ;ʮ����ת������
    cmp [si],'#'
    je finish_dec_to_bin  
    cmp [si],'.'         ;����С����
    je  next_dec_to_bin
    mul cl
    mov dl,[si]
    sub dl,'0'
    add al,dl
    inc si   
    jmp lp_dec_to_bin
    
  next_dec_to_bin:
    inc si
    jmp lp_dec_to_bin  
    
  finish_dec_to_bin:   
    mov bx , offset student+xgrade
    mov word ptr[bx],ax 
    
    pop bx
    pop si
    pop dx
    pop ax
    pop cx
    ret
dec_to_bin endp
;--------------------------------------------16λ������ת10����,������ʾ����Ļ��,��ջ������------------------------
bin_to_dec proc
    
    ret
bin_to_dec endp   
;-------------------------------------------ʮ���ƴ�С���洢���������----------------------------------

;--------------------------------------------��ƽ������------------------------------
get_average proc 
    
       mov bx,offset buf
       mov ax,0
       mov cx,num ;ѭ������ 
       cmp cx,0
       je   wrong   ;CX=0ʱ����ѭ����˵��û��ѧ����ֱ�ӱ���
       lp_average:
        add ax,[bx+xgrade]
       loop lp_average 
       
       ;32λ�������ȱ�����DX����ֹ���ı�
       push dx
       mov cx,num
       div cx    ;���ж����������㣬С������*10���������Ȼ��������
       cmp dx,000
       
       pop dx
          
       push ax
       call bin_to_dec
       ret
get_average endp
code ends
end start 


