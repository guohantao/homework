data segment
    hexbuf dw 3f5ah
    ascbuf dB 4 DUP(0)
data ends

code segment
    assume cs:code, ds:data
    start:
        mov ax,data
        mov ds,ax  
        
        mov cl,4
        mov ax,hexbuf  
        
        mov dl,ah
        shr dl,cl  ;ȡ3
        
        cmp dl,9
        ja  asciiword
        jmp asciinum
        
        asciiword:
           sub dl,10
           add dl,'A'
           mov ascbuf[0],dl
           jmp next1
        
        asciinum:
            add dl,'0'
            mov ascbuf[0],dl  
            jmp next1
        next1: 
        
        
        mov dl,ah
        and dl,0fH  ;ȡF
        
        cmp dl,9
        ja  asciiword2
        jmp asciinum2
        
        asciiword2:
           sub dl,10
           add dl,'A'
           MOV ASCBUF[1],dl
           jmp next2
        
        asciinum2:
            add dl,'0'
            mov ascbuf[1],dl  
            jmp next2
        next2:   
        
        mov dl,al
        shr dl,cl  ;ȡ5
        
        cmp dl,9
        ja  asciiword3
        jmp asciinum3
        
        asciiword3:
           sub dl,9
           add dl,'A'
           MOV ASCBUF[2],dl
           jmp next3
        
        asciinum3:
            add dl,'0'
            mov ascbuf[2],dl  
            jmp next3
        next3:     
        
        
        mov dl,al
        and dl,0fH  ;ȡA
        
        cmp dl,9
        ja  asciiword4
        jmp asciinum4
        
        asciiword4:
           sub dl,10
           add dl,'A'
           MOV ASCBUF[3],dl
           jmp next4
        
        asciinum4:
            add dl,'0'
            mov ascbuf[3],dl  
            jmp next4
        next4:
           
       
       
       
        mov ax,4c00h
        int 21h
code ends
end start
     
            