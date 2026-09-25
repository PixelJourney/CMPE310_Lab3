.section .bss
.globl ram
.lcomm ram, 512 #Reserve 256 bytes of RAM for each string (uninitialized memory)
.lcomm len1, 8  #reserve 8 bytes of RAM for len1 and len 2
.lcomm len2, 8 

.globl hamResult
.lcomm hamResult, 8


.section .rodata
prompt1: 
    .ascii "Enter first string: "
prompt2:
    .ascii "Enter second string: "

.section .text
.globl checkHam            # Make function visible to C program
checkHam:

    mov $20, %rdx               # number of bytes to print
    mov $1, %rax                #write
    mov $1, %rdi                #out to terminal
    lea prompt1(%rip), %rsi     #address of prompt1
    syscall

    mov $0, %rax                # read
    mov $0, %rdi                # take input from user
    mov $255, %rdx              # max amount of bytes to read from input
    lea ram(%rip),%rsi          # store input starting at ram
    syscall
    mov %rax, len1(%rip)        # store first string length in len1


    mov $21, %rdx               # number of bytes to print
    mov $1, %rax                #write
    mov $1, %rdi                #out to terminal
    lea prompt2(%rip), %rsi     #address of prompt2
    syscall

    mov $0, %rax                # read
    mov $0, %rdi                # take input from user
    mov $255, %rdx              # max amount of bytes to read from input
    lea ram+256(%rip),%rsi      # store input starting at ram
    syscall
    mov %rax, len2(%rip)        # store second string length in len2


    mov len1(%rip), %rax        # move first string into rax
    cmp len2(%rip), %rax        # compare first string to second string in length
    jbe len1_is_shorter         # jump if len1 is shorter than len2 

    # if len2 is shorter
    mov len2(%rip), %rdx
    dec %rdx
    jmp length_compare

    #jump here if len1 is shorter
    len1_is_shorter:
        mov %rax, %rdx
        dec %rdx

        
    length_compare:            
        xor %rcx, %rcx                # set hamming distance count to 0
        
        lea ram(%rip), %rsi           # first string address
        lea ram+256(%rip), %rdi       # second string address
    
    character_loop:        
        movb (%rsi), %al                # get current character from 1st string
        movb (%rdi), %bl                # get current character from 2nd string
        
        xorb %bl, %al                # find different bits
        mov $8, %r8                # 8 bits to check for each character

    bit_loop:        
        testb $1, %al            #check if current bit is a 1
        jz bit_is_zero            #if bit is 0 skip adding to hamming
        inc %rcx

    bit_is_zero:                #shift to check next bit
        shrb $1, %al            
        dec %r8
        jnz bit_loop            #keep checking until all 8 bits have been checked
    
        inc %rsi                # move to next character in first string
        inc %rdi                # move to next character in second string
        dec %rdx                # subtract 1 from characters left to compare
        jnz character_loop      # loop until all characters are checked

    mov %rcx, hamResult(%rip)    #store final hamming distance in hamResult
    ret

.section .note.GNU-stack,"",@progbits
