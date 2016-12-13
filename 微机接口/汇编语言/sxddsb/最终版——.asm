
;student struc 
;    xname   db 10db
;    xclass  db 10db
;    xnumber db 10db
;    xgrade  db 2db  ;�Զ����������棬����*10����������ʾС��
;student ends


data segment  
    cr equ 0dh��0ah ;�س�+���� 
    space equ 32 ;�ո�         
    
    
    
    str1 db cr,cr,'please input the function you want to��',cr,'1. add grade  2.sort  3.get average 4.get the number of each rank',cr,'$'
    str2 db cr,'please the sort way�� 1.by number  2.by grade',cr,'$'
    str3 db cr,'please the student: name , class , number , grade.',cr,'!!!!!!!divid by /,end by #!!!!!!!! ',cr,'(name, class, number size should smaller than 10 db and not permit space)',cr,'$'
    str4 db cr,'input wrong,try again',cr,'$' 
    str5 db cr,'the average is :$'
    str6 db cr,'the result are (0-60,60-70,70-80,80-90,90-100):$'
    str7 db cr,'name:     class:    number:   grade��',cr,'$'
    str8 db cr,'it maybe takes a lot time please wait',cr,'$'
    
    
    in_buf db 50,0,50 dup(0)  ;���뻺��buf  in_buf[2]����������Ŀ�ʼ 
    num_buf db 5 dup(20h),'$'
            
    
;--------------------------------------------------------------------------------------------------     
    num  dw 0   ; ѧ������ 
    half_num db 0; ��ƽ��ʱ����������Ҫ��  
               ;����       �༶         ѧ��         �ɼ�    �س�����
    student db 10 dup(' '),10 dup(' '),10 dup(' '), 2 dup(0),  cr
    
    buf db   20*student_db dup(' '),'$'    ;20��ѧ����buf
    buf2 db  20*student_db dup(' '),'$'   ;����ʱ��ռ������ 
    student_db equ 34  ;һ��ѧ��ռ32db,���лس�ռ2db
    xname equ 0  ;��һ��ѧ���ṹ����ƫ����Ϊ0 
    xclass equ 10  ;��һ��ѧ���ṹ����ƫ����Ϊ10  
    xnumber equ 20  ;��һ��ѧ���ṹ����ƫ����Ϊ20
    xgrade equ 30  ;��һ��ѧ���ṹ����ƫ����Ϊ30 
    buf_end dw 0 ;�洢bufβ���ĵ�ַ  
    
    
;--------------------------------------------------------------------------------------------------
        
    flag dw 0  ;copystr�����У�������λ�����ı�� 
    flag1 dw 0 ;���� ��ʾ����ʮ������ -1  ���Ǵ�С����ʮ������ -0
    0_60 dw 0
    60_70 dw 0
    70_80 dw 0
    80_90 dw 0
    90_100 dw 0
    
;-----------------------------------------------------------------------------------------------------
    max_offset dw 0 ;���ֵ��ƫ�Ƶ�ַ 
    number db 10 dup(0) ;�Ƚ�ѧ�Ŵ�Сʱ�õ�
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
         cmp dl,'2'
         je sort
         cmp dl,'3'
         je average
         cmp dl,'4'
         je get_num_rank 
         
         ;����������� 
      wrong:   
         call flush_in_buf ;!!!!!!!!!!!���in_ buf
         mov dx,offset str4
         call print
         jmp begin  
         
         
         
;---------------------------------------------��ӳɼ�----------------------------------------------
        add_grade: 
            call flush_in_buf
            mov dx,offset str3
            call print
            call gets 
            call copystr ;��in_buf�е����ݿ�����buf�� student��ʽ
            
            add  buf_end,student_db
            mov bx,buf_end
            mov [bx],'$'
            inc num ;ѧ������+1  
            call flush_in_buf ;!!!!!!!!!!!���in_ buf 
            jmp begin
            
;---------------------------------------------����-------------------------------------------------
        sort:  
           ;�ձ�ʱ��������
            mov cx,num
            cmp cx,0
            je wrong
            
           
            
            mov dx,offset str2
            call print
            call gets
           ;�ж��Ƿ���ȷ����
            mov dl,in_buf[3]
            cmp dl,0dh
            jne wrong 
            
             ;��ӡ��ͷ
            mov dx,offset str8
            call print          
            mov dx,offset str7
            call print  
            
            mov dl,in_buf[2]
            cmp dl,'1'
            je  sort_by_number
            cmp dl,'2'
            je sort_by_grade 
            jmp wrong
          
          
            
          sort_by_number: 
            call sort_number 
            jmp sort_finish
          sort_by_grade: 
            call sort_grade
            jmp sort_finish
            
           sort_finish:
              
              call print_table
              jmp begin
            
;---------------------------------------------��ƽ��-----------------------------------------------
        average: 
           mov dx , offset str5
           call print
           mov ax,0   
           mov ax,num
           mov cx,2
           div cl
           mov half_num,al
           call get_average  
           
           
           
           
           jmp begin
            
;--------------------------------------------��������ͳ��--------------------------------------------
        get_num_rank: 
            call  get_count
        
        
        jmp begin

;---------------------------------------------��������-------------------------------------------       
       endprogram:  
        mov ax,4c00h
        int 21h   
        
        
        
        
        
        
;--------------------------------------------��ӡ����------------------------------
print proc near
      mov ah,09h
      int 21h
      ret
print endp  

;-------------------------------------------��ӡѧ������--------------------------
print_table proc
    push bx 
    push cx
    
    mov bx , offset buf
    mov cx,num
   lp_table:
    push bx 
      push cx
        mov cx,30
       lp_word:
        mov ax,0
        mov dl,[bx]
        mov ah,02h
        int 21h
        inc bx 
       loop lp_word
      pop cx
      mov ax,[bx]
      call bin_to_dec 
      mov ah,02h 
      mov dl,0ah
      int 21h
      mov ah,02h 
      mov dl,0dh
      int 21h 
     pop bx
     add bx,student_db
     loop lp_table
    
    
    pop cx
    pop bx
    ret
print_table endp
;-------------------------------------------��ȡ���뺯�����ַ���---------------------------------
gets proc near
    
    mov ah,0ah  
    mov dx,offset in_buf
    int 21h 
    
    ret
gets endp   

;-------------------------------------------���in_buf����-------------------------------
flush_in_buf proc
    push cx
    push ax
    push bx
    
      mov ax,0 
      mov bx,offset in_buf 
      add bx,2
      mov cx,50
      lp_flush:
        mov [bx],' '
        inc bx
        loop lp_flush
        
    pop bx  
    pop ax
    pop cx
    
    ret
flush_in_buf endp



;--------------------------------------------�ַ�����������,��in_buf ���涨��student��ʽ������buf��-----------------------------------
copystr proc
    push si
    push di  
    push bx
    
    mov si,offset in_buf +2 ;in_buf[2]����������Ŀ�ʼ
    mov di,buf_end
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
        mov bx,buf_end  
        add bx,xclass
        mov di, bx
        inc si
        inc flag
        jmp lp_copy
    offset_num:
        mov bx,buf_end  
        add bx,xnumber
        mov di, bx
        inc si 
        inc flag
        jmp lp_copy
             
    finish_copy:
        inc si 
        mov flag,0 
    call dec_to_bin 
    mov bx,buf_end
    add bx,32
    mov [bx],0ah
    inc bx
    mov [bx],0dh 
    
    pop bx  
    pop di
    pop si
    ret
copystr endp   
;--------------------------------------------��Ļ�е�10����ת16λ2������,�浽��Ӧbuf-xgrade��-------------------------------------
dec_to_bin proc
    push cx
    push ax
    push dx
    push si 
    push bx
    
    mov ax,0
    mov dx,0
    mov cx,10 ;CX�ǳ���
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
    mov bx ,  buf_end
    add bx,xgrade
    mov word ptr[bx],ax 
    
    pop bx
    pop si
    pop dx
    pop ax
    pop cx
    ret
dec_to_bin endp
;--------------------------------------------16λ������ת10����,������ʾ����Ļ��,AX������------------------------
bin_to_dec proc
    push cx
    push bx
    push dx
    
    ;num_buf����
    mov bx,offset num_buf
    mov cx,5
  zero: 
    mov [bx],32
    inc bx
    loop zero
    
    
   ;�жϽ���������ʾ���ǣ���С����������ʾ 
    mov cx,flag1 
    mov dx,0   ;DX����
    cmp cx,0 
    je  decimals          ;����С����ʾ
    jmp integer           ;����������ʾ
    
   decimals:
    mov bx,offset num_buf
    add bx,4
    mov cx,10
    div cx 
    mov [bx],dl 
    add [bx],'0'
    dec bx
    mov [bx],'.'
    jmp lp_bin_to_dec
    
    
   integer:
    mov bx,offset num_buf
    add bx,2
    mov cx,10
    div cx
    mov [bx],dl
    add [bx],'0'
    
  lp_bin_to_dec:  
    dec bx
    mov dx,0 
    div cx
    mov [bx],dl
    add [bx],'0' 
    cmp ax,0 
    jnz lp_bin_to_dec
    
    mov dx,offset num_buf 
    call print
    
    
    pop dx
    pop bx
    pop cx
    ret
bin_to_dec endp   


;--------------------------------------------��ƽ������------------------------------
get_average proc 
    
       mov bx,offset buf
       mov ax,0
       mov cx,num ;ѭ������ 
       cmp cx,0
       je   wrong   ;CX=0ʱ����ѭ����˵��û��ѧ����ֱ�ӱ���
       lp_average:
        add ax,[bx+xgrade]
        add bx,student_db
       loop lp_average 
       
       ;��32λ�㣬��������
       push dx 
       mov dx,0
       mov cx,num
       div cx    ;���ж����������㣬С������*10���������Ȼ��������
       cmp dl,half_num 
       ja average_add
       jmp average_output 
       
      average_add:
        inc ax
      average_output: 
        mov dx,0
        call bin_to_dec  
       
       pop dx
 
       ret
get_average endp 
;------------------------------------------------ͳ�ƺ���----------------------------------
get_count proc
    mov 0_60,0
    mov 60_70,0
    mov 70_80,0
    mov 80_90,0
    mov 90_100,0
    
    push cx
    push ax 
    push bx
    push dx
     
     
     mov dx,offset str6
     call print
     
     mov cx,num
     mov bx,offset buf
     mov ax,0
     cmp cx,0
     jne lp_count 
     mov dx,offset str4
     call print
     jmp count_finish
     
       
  lp_count:   
     mov ax,[bx+xgrade]
     add bx,student_db 
     ;ע�⣬�ɼ��ǣ�*10֮��Ϊ��ȡ�������ڴ��У�����Ӧ�ú�600 700 800 900 1000�Ƚ�
     cmp ax,600
     jb  add_0_60
     cmp ax,700
     jb  add_60_70
     cmp ax,800
     jb  add_70_80
     cmp ax,900
     jb  add_80_90
     cmp ax,1000
     jbe  add_90_100
     
     
     add_0_60: 
        inc 0_60 
        jmp count_next
     add_60_70: 
        inc 60_70
        jmp count_next
     add_70_80: 
        inc 70_80
        jmp count_next
     add_80_90: 
        inc 80_90
        jmp count_next
     add_90_100: 
        inc 90_100
        jmp count_next
        
     count_next:
      loop lp_count
     
    mov flag1 ,1    ;��ʾ����ʮ������
    
    mov cx,5 
    mov bx,offset 0_60
  count_out_lp:  
    mov ax,[bx]
    call bin_to_dec
    add bx,2
    loop count_out_lp: 
     
    mov flag1,0      ;flag1���� 
    
  count_finish:
    
    pop dx
    pop bx
    pop ax
    pop cx
    
    ret
get_count endp         

;--------------------------------------sort-number----------------------------------------
sort_number proc
    push cx
    push di
    push si 
    
    mov di,offset buf2
    
    mov cx,num ;cx,���������ж��ٸ��ˣ���Ҫ�������ٴ�  
    ;����ֻ��һ���ˣ���ֱ�Ӵ�ӡ
    cmp cx,1
    je sort_number_finish_num=1
    
  lp_sort_number:  ;ѭ������number sort buf1 ��copy ��buf2
     call max_number  ;�����ҵ�BUF�������������Ұѵ�ַ����max_offset��
     mov si,max_offset 
     ;��Ŀǰbuf1����������max_offset)copy��buf2
     push cx   
        mov cx,student_db
        rep movsb
          ;��buf��max_offsetָ���ѧ��ѧ�Ÿ�Ϊ��С���Ա��´������ҵ��ڶ����number
       push bx 
        mov cx,10
        mov bx,max_offset
        add bx,xnumber 
       lp_change_number:    ;��������number��Ϊ��С
        mov [bx],0
        inc bx      
        loop lp_change_number
       pop bx   
     pop cx 
     
     loop lp_sort_number
    mov bx,di
    mov [bx],'$' 
    
    ;��buf2 ���Ƶ� buf1
    mov si,offset buf2 
    mov di,offset buf  
  sort_buf2_to_buf_n: 
    movsb
    cmp [si-1],'$'
    je sort_number_finish 
    jmp  sort_buf2_to_buf_n
    
  ;����ֻ��һ���ˣ���ֱ�Ӵ�ӡ
  sort_number_finish_num=1��
    mov bx,offset buf +student_db
    mov [bx],'$'
    
  sort_number_finish:
    
    
    pop si
    pop di
    pop cx
    ret
sort_number endp


;-------------------------------------���number,�������number ��offset  ------------------
max_number proc
    push bx 
    push ax
    push cx
    push dx
    push di
    
    mov ax,0
    mov dx,0
    mov cx,num 
    mov bx,offset buf
    ;��number����ֵ����ʼ���Ƚ�
     push bx
      mov max_offset,bx ;��������ѧ�ŵ�ѧ����ַ�Ƶ�max_offset�� 
      add bx,xnumber
      mov si,bx
      mov di,offset number
      push cx
        mov cx,10
        rep movsb
      pop cx
     pop bx
    add bx,student_db 
    cmp cx,1
    je   finish_number_sort   ;�������ֻ��һ���ˣ���ֱ�ӽ���ѭ��
    dec cx
    
     
    
  lp_find_max_number: ;ɨ��buf ���ҵ�����number
     
    push cx
      mov cx,10
      mov si,offset number
    push bx 
     add bx,xnumber
     lp_number_compare:
      mov ax,0  ;ax����
      mov al,[bx] ;ȡһ��ѧ����ѧ�ŵ�һλ�뵱ǰ���ѧ�ŵ�һλ��Ƚ�
      cmp al,[si]
      ja  max_number_change  ;���ѧ����һλ��ѧ�Ŵ��ڵ�ǰ���ѧ�ŵ���һλ��������ѧ��Ϊ��ǰѧ�� 
      cmp al,[si]
      je next_number        ;�������,�Ƚ���һλ  
      cmp al,[si]
      jb  finish_number_compare      ;���С�ڣ��ȽϽ���
        
        
   ;���ѧ���Ľ����Ƚϣ�����ѧ�ŷŵ�number��
  max_number_change:
     push bp
      mov bp,sp  ;bpĬ�϶μĴ�����ss ����sp��ֵ��bp,�����ڲ��ı�ջ������£��������ջ������
      add bp,2   ;bpָ��ջ�е� bx(���ѧ�����׵�ַ�� ��ջ������һλ���� ����ǰջ����BPԭ��������
      mov bx,[bp] ;bxָ��ǰѧ�����׵�ַ
      mov max_offset,bx ;��������ѧ�ŵ�ѧ����ַ�Ƶ�max_offset��
      add bx,xnumber
        mov si,bx
        mov di,offset number
        push cx  ;���浱ǰ��������ֵ����ֹ�ı�
         mov cx,10
         rep movsb
        pop cx   ;�ָ���������ֵ
    pop bp 
     jmp finish_number_compare
      
      
   next_number:
        inc bx
        inc si
        loop lp_number_compare
   finish_number_compare: 
    pop bx
    pop cx 
     add bx,student_db  ;bxָ����һ��ѧ�����׵�ַ
     loop  lp_find_max_number  ;������һ��ѧ���ıȽ�
   
   finish_number_sort:    
 
    pop di   
    pop dx
    pop cx
    pop ax
    pop bx
    ret
max_number endp

;--------------------------------------sort-grade-----------------
sort_grade proc
    push cx
    push di
    push si 
    
    mov di,offset buf2  
    
    mov cx,num ;����ѭ������ 
    ;��grade sort buf1 ��copy ��buf2
  lp_sort_grade:  
     call max_grade ;�ҵ����ɼ������ҷ��ظ�ѧ���ĵ�ַ max_offset 
     mov si,max_offset  
     ;��Ŀǰbuf1�������� (max_offset) copy��buf2
     push cx  
        mov cx,student_db
        rep movsb
        push bx 
        mov bx,max_offset
        mov word ptr [bx+xgrade],-0    ;������������Ϊ��С��,��������-1����Ϊ-1��255�Ĳ�����ͬ�����ܱȽϴ�С ,(���ɼ���25.5ʱ��*10������255)
        pop bx
     pop cx
     loop lp_sort_grade 
     ;��buf2���ý�β���š�$'
    mov bx,di
    mov [bx],'$' 
    
    ;��buf2 ���Ƶ� buf1
    mov si,offset buf2 
    mov di,offset buf  
  sort_buf2_to_buf: 
    movsb
    cmp [si-1],'$'
    je sort_grade_finish 
    jmp  sort_buf2_to_buf
    
    
  sort_grade_finish:
    pop si
    pop di
    pop cx
    ret
sort_grade endp  


;-------------------------------------���grade--------------------
max_grade proc
    push bx 
    push ax
    push cx
    push dx
    
    mov cx,num 
    mov bx,offset buf
    mov dx,[bx+xgrade]
    mov max_offset,bx  
    cmp cx,1
    je   max_grade_next   ;�������ֻ��һ���ˣ���ֱ�ӽ���ѭ��
    dec cx 
    
    
  lp_max_grade:   ;ɨ��buf�ҵ�����grade  
    add bx,student_db
    mov ax,[bx+xgrade]
    cmp ax,dx
    jg  grade_max
    jmp max_grade_next
    
    
  grade_max:
    mov dx,ax
    mov max_offset,bx
    jmp  max_grade_next
      
  max_grade_next:  
    loop lp_max_grade
    
    pop dx
    pop cx
    pop ax
    pop bx
    ret
max_grade endp
;-----------------------------------------------------------------------------------------------
code ends
end start 


