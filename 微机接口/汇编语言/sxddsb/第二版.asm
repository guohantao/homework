
;student struc 
;    xname   db 10db
;    xclass  db 10db
;    xnumber db 10db
;    xgrade  db 2db  ;以二进制数保存，并且*10，用整数表示小数
;student ends


data segment  
    cr equ 0dh，0ah ;回车+换行 
    space equ 32 ;空格         
    
    
    
    str1 db cr,cr,'please input the function you want to：',cr,'1. add grade  2.sort  3.get average 4.get the number of each rank',cr,'$'
    str2 db cr,'please the sort way： 1.by number  2.by grade',cr,'$'
    str3 db cr,'please the student: name , class , number , grade.',cr,'!!!!!!!divid by /,end by #!!!!!!!! ',cr,'(name, class, number size should smaller than 10 db and not permit space)',cr,'$'
    str4 db cr,'input wrong,try again',cr,'$' 
    str5 db cr,'the average is :$'
    str6 db cr,'the result are (0-60,60-70,70-80,80-90,90-100):$'
    str7 db cr,'name:',5 dup(''),'class:',4 dup(''),'number:', 3 dup(''),'grade：',cr,'$'
    
    
    in_buf db 50,0,50 dup(0)  ;输入缓存buf  in_buf[2]才是数据域的开始 
    num_buf db 5 dup(20h),'$'
            
    
;--------------------------------------------------------------------------------------------------     
    num  dw 0   ; 学生总数 
    half_num db 0; 求平均时，四舍五入要用  
               ;姓名       班级         学号         成绩    回车换行
    student db 10 dup(' '),10 dup(' '),10 dup(' '), 2 dup(0),  cr
    
    buf db   20*student_db dup(' '),'$'    ;20个学生的buf
    buf2 db  20*student_db dup(' '),'$'   ;排序时的占存数组 
    student_db equ 34  ;一个学生占32db,换行回车占2db
    xname equ 0  ;在一个学生结构体里偏移量为0 
    xclass equ 10  ;在一个学生结构体里偏移量为10  
    xnumber equ 20  ;在一个学生结构体里偏移量为20
    xgrade equ 30  ;在一个学生结构体里偏移量为30 
    buf_end dw 0 ;存储buf尾部的地址  
    
    
;--------------------------------------------------------------------------------------------------
        
    flag dw 0  ;copystr函数中，用来做位移量的标记 
    flag1 dw 0 ;区分 显示整数十进制数 -1  还是带小数的十进制数 -0
    0_60 dw 0
    60_70 dw 0
    70_80 dw 0
    80_90 dw 0
    90_100 dw 0
    
;-----------------------------------------------------------------------------------------------------
    max_offset dw 0 ;最大值的偏移地址
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
         
         ;输入错误，重试 
      wrong:
         mov dx,offset str4
         call print
         jmp begin  
         
         
         
;---------------------------------------------添加成绩----------------------------------------------
        add_grade: 
            call flush_in_buf
            mov dx,offset str3
            call print
            call gets 
            call copystr ;将in_buf中的数据拷贝到buf按 student格式
            
            add  buf_end,student_db
            mov bx,buf_end
            mov [bx],'$'
            inc num ;学生总数+1  
            call flush_in_buf ;!!!!!!!!!!!清空in_ buf 
            jmp begin
            
;---------------------------------------------排序-------------------------------------------------
        sort:  
           ;空表时不能排序
            mov cx,num
            cmp cx,0
            je wrong
              
            mov dx,offset str2
            call print
            call gets
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
              mov dx,offset str7
              call print
              call print_table
              jmp begin
            
;---------------------------------------------求平均-----------------------------------------------
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
            
;--------------------------------------------按分数段统计--------------------------------------------
        get_num_rank: 
            call  get_count
        
        
        jmp begin

;---------------------------------------------结束程序-------------------------------------------       
       endprogram:  
        mov ax,4c00h
        int 21h   
        
        
        
        
        
        
;--------------------------------------------打印函数------------------------------
print proc near
      mov ah,09h
      int 21h
      ret
print endp  

;-------------------------------------------打印学生表函数--------------------------
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
        mov al,[bx]
        mov ah,02h
        int 21h
        inc bx
      pop cx
      mov ax,[bx]
      call bin_to_dec 
      mov ax,020ah
      int 21h
      mov ax,020dh
      int 21h 
     pop bx
     add bx,student_db
     loop lp_table
    
    
    pop cx
    pop bx
    ret
print_table endp
;-------------------------------------------获取输入函数，字符串---------------------------------
gets proc near
    mov ah,0ah  
    mov dx,offset in_buf
    int 21h 
    
    ret
gets endp   

;-------------------------------------------清空in_buf缓存-------------------------------
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



;--------------------------------------------字符串拷贝函数,将in_buf 按规定的student格式拷贝到buf中-----------------------------------
copystr proc
    push si
    push di  
    push bx
    
    mov si,offset in_buf +2 ;in_buf[2]才是数据域的开始
    mov di,buf_end
    cld ;按递增方式复制
   lp_copy:
    cmp [si],'/'
    je  judge_offset
    movsb ;si,di自动加1
    jmp lp_copy
    
    judge_offset:
       cmp flag,0
       je offset_class    ;将DI的指针移到存class区域开始
       cmp flag,1
       je offset_num      ;将DI的指针移到存number区域开始
       cmp flag,2
       je finish_copy     ;将DI的指针移到存grade区域开始
       
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
;--------------------------------------------屏幕中的10进制转16位2进制数,存到相应buf-xgrade中-------------------------------------
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
    ;十进制转二进制
    cmp [si],'#'
    je finish_dec_to_bin  
    cmp [si],'.'         ;遇到小数点
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
;--------------------------------------------16位二进制转10进制,并且显示在屏幕上,AX传参数------------------------
bin_to_dec proc
    push cx
    push bx
    push dx
    
    ;num_buf清零
    mov bx,offset num_buf
    mov cx,5
  zero: 
    mov [bx],32
    inc bx
    loop zero
    
    
   ;判断进行整数显示还是，带小数的整数显示 
    mov cx,flag1 
    mov dx,0   ;DX清零
    cmp cx,0 
    je  decimals
    jmp integer
    
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


;--------------------------------------------求平均函数------------------------------
get_average proc 
    
       mov bx,offset buf
       mov ax,0
       mov cx,num ;循环次数 
       cmp cx,0
       je   wrong   ;CX=0时，不循环，说明没有学生，直接报错
       lp_average:
        add ax,[bx+xgrade]
        add bx,student_db
       loop lp_average 
       
       ;用32位算，否则会溢出
       push dx 
       mov dx,0
       mov cx,num
       div cx    ;所有都当成整数算，小数部分*10变成整数，然后做运算
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
;------------------------------------------------统计函数----------------------------------
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
     ;注意，成绩是，*10之后，为了取整存在内存中，所以应该和600 700 800 900 1000比较
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
     
    mov flag1 ,1    ;显示整数十进制数
    
    mov cx,5 
    mov bx,offset 0_60
  count_out_lp:  
    mov ax,[bx]
    call bin_to_dec
    add bx,2
    loop count_out_lp: 
     
    mov flag1,0      ;flag1清零 
    
  count_finish:
    
    pop dx
    pop bx
    pop ax
    pop cx
    
    ret
get_count endp         

;--------------------------------------sort-number---------------
sort_number proc
    push cx
    push di
    push si 
    
    mov di,offset buf2
    
    mov cx,num 
  lp_sort_number:  ;按number sort buf1 并copy 到buf2
     call max_number  
     mov si,max_offset
     push cx   ;将目前buf1中最大的数copy到buf2
        mov cx,student_db
        rep movsb
        
        push bx 
        mov cx,10
        mov bx,max_offset
        add bx,xnumber 
       lp_change_number:    ;将这个最大number改为最小
        mov [bx],0
        inc bx      
        loop lp_change_number
        pop bx
        
     pop cx
     loop lp_sort_number
    mov bx,di
    mov [bx],'$' 
    
    ;将buf2 复制到 buf1
    mov si,offset buf2 
    mov di,offset buf  
  sort_buf2_to_buf_n: 
    movsb
    cmp [si-1],'$'
    je sort_number_finish 
    loop  sort_buf2_to_buf_n
    
    
  sort_number_finish:
    
    
    pop si
    pop di
    pop cx
    ret
sort_number endp

;--------------------------------------sort-grade-----------------
sort_grade proc
    push cx
    push di
    push si 
    
    mov di,offset buf2  
    
    mov cx,num 
  lp_sort_grade:  ;按grade sort buf1 并copy 到buf2
     call max_grade  
     mov si,max_offset
     push cx   ;将目前buf1中最大的数copy到buf2
        mov cx,student_db
        rep movsb
        push bx 
        mov bx,max_offset
        mov [bx+xgrade],-0    ;将这个最大数改为最小数,不能设置-1，因为-1与255的补码相同，不能比较大小 
        pop bx
     pop cx
     loop lp_sort_grade
    mov bx,di
    mov [bx],'$' 
    
    ;将buf2 复制到 buf1
    mov si,offset buf2 
    mov di,offset buf  
  sort_buf2_to_buf: 
    movsb
    cmp [si-1],'$'
    je sort_grade_finish 
    loop  sort_buf2_to_buf
    
    
  sort_grade_finish:
    pop si
    pop di
    pop cx
    ret
sort_grade endp  

;-------------------------------------最大number------------------
max_number proc
    push bx 
    push ax
    push cx
    push dx
    
    mov ax,0
    mov dx,0
    mov cx,num 
    mov bx,offset buf 
    
  lp_find_max_number: ;扫描buf ，找到最大的number
   push bx
    add bx,xnumber 
    mov ax,0
      push cx
        mov cx,10
       lp_sum_number:    ;对number 的ascii求和 来判断谁最大
        add al,[bx] 
        inc bx
        loop lp_sum_number
      pop cx
   pop bx
     cmp ax,dx
     ja  number_max
     jmp number_next
     
     
     number_max: 
        mov max_offset,bx 
        mov dx,ax
        jmp number_next
     
     number_next:
        add bx,student_db
        loop lp_find_max_number 
       
    pop dx
    pop cx
    pop ax
    pop bx
    ret
max_number endp

;-------------------------------------最大grade--------------------
max_grade proc
    push bx 
    push ax
    push cx
    push dx
    
    mov cx,num 
    mov bx,offset buf
    mov dx,[bx+xgrade]
    mov max_offset,bx
    add bx,student_db
    dec cx
    
  lp_max_grade:   ;扫描buf找到最大的grade
    mov ax,[bx+xgrade]
    cmp ax,dx
    jg  grade_max
    jmp max_grade_next
    
    
  grade_max:
    mov dx,ax
    mov max_offset,bx
    jmp  max_grade_next
      
  max_grade_next:  
    add bx,student_db
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


