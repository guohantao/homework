
;student struc 
;    xname   db 10db
;    xclass  db 10db
;    xnumber db 10db
;    xgrade  db 2db  ;以二进制数保存，并且*10，用整数表示小数
;student ends


data segment  
    cr equ 0dh，0ah ;回车+换行 
    tab equ 9 ;tab         
    
    
    
    str1 db 'please input the function you want to：',cr,'1. add grade  2.sort  3.get average 4.get the number of each rank',cr,'$'
    str2 db cr,'please the sort way： 1.by number  2.by grade',cr,'$'
    str3 db cr,'please the student: name , class , number , grade,divid by /,end by # ',cr,'(name, class, number size should smaller than 10 db and not permit space)',cr,'$'
    str4 db cr,'input wrong,try again',cr,'$' 
    
    
    in_buf db 50,0,50 dup(0)  ;输入缓存buf  in_buf[2]才是数据域的开始
            
    
     
    num  dw 0   ; 学生总数 
      
               ;姓名       班级         学号         成绩    回车换行
    student db 10 dup(' '),10 dup(' '),10 dup(' '), 2 dup(0),  cr
    
    buf db   20*student_db dup(0)    ;20个学生的buf 
    student_db equ 34  ;一个学生占32db,换行回车占2db
    xname equ 0  ;在一个学生结构体里偏移量为0 
    xclass equ 10  ;在一个学生结构体里偏移量为10  
    xnumber equ 20  ;在一个学生结构体里偏移量为20
    xgrade equ 30  ;在一个学生结构体里偏移量为30 
    buf_end dw 0 ;存储buf尾部的地址
    
    flag db 0  ;copystr函数中，用来做位移量的标记
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
         
         ;输入错误，重试 
      wrong:
         mov dx,offset str4
         call print
         jmp begin  
         
         
         
;---------------------------------------------添加成绩----------------------------------------------
        add_grade: 
            mov dx,offset str3
            call print
            call gets 
            call copystr ;将in_buf中的数据拷贝到 student格式中
            ;将student拷贝到buf中
            mov si,offset student
            mov di,buf_end
            mov cx,student_db
            cld
            rep movsb
            
            add  buf_end,student_db
            inc num ;学生总数+1  
            call flush_in_buf_and_student ;!!!!!!!!!!!清空student 和 buf
            
;---------------------------------------------排序-------------------------------------------------
        sort: 
            mov bx,offset buf
            
;---------------------------------------------求平均-----------------------------------------------
        average:
           call get_average
            
;--------------------------------------------按分数段统计--------------------------------------------
        get_num_rank:
         
        mov ax,4c00h
        int 21h   
        
        
        
        
        
        
;--------------------------------------------打印函数------------------------------
print proc near
      mov ah,09h
      int 21h
      ret
print endp  

;-------------------------------------------获取输入函数，字符串---------------------------------
gets proc near
    mov ah,0ah  
    mov dx,offset in_buf
    int 21h 
    
    ret
gets endp   

;--------------------------------------------字符串拷贝函数,将in_buf 按规定的student格式拷贝到student中-----------------------------------
copystr proc
    push si
    push di
    
    mov si,offset in_buf +2 ;in_buf[2]才是数据域的开始
    lea di,student
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
;--------------------------------------------屏幕中的10进制转4位2进制数-------------------------------------
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
    mov bx , offset student+xgrade
    mov word ptr[bx],ax 
    
    pop bx
    pop si
    pop dx
    pop ax
    pop cx
    ret
dec_to_bin endp
;--------------------------------------------16位二进制转10进制,并且显示在屏幕上,堆栈传参数------------------------
bin_to_dec proc
    
    ret
bin_to_dec endp   
;-------------------------------------------十进制带小数存储到计算机中----------------------------------

;--------------------------------------------求平均函数------------------------------
get_average proc 
    
       mov bx,offset buf
       mov ax,0
       mov cx,num ;循环次数 
       cmp cx,0
       je   wrong   ;CX=0时，不循环，说明没有学生，直接报错
       lp_average:
        add ax,[bx+xgrade]
       loop lp_average 
       
       ;32位除法，先保存下DX，防止被改变
       push dx
       mov cx,num
       div cx    ;所有都当成整数算，小数部分*10变成整数，然后做运算
       cmp dx,000
       
       pop dx
          
       push ax
       call bin_to_dec
       ret
get_average endp
code ends
end start 


