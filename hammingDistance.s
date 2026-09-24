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


    mov len1(%rip), %rax
    cmp len2(%rip), %rax
    jbe len1_is_shorter

    # if len2 is shorter
    mov len2(%rip), %rdx
    dec %rdx
    jmp length_compare

    #jump here if len1 is shorter
    len1_is_shorter:
        mov %rax, %rdx
        dec %rdx

        
    length_compare:
        xor %rcx, %rcx
        
        lea ram(%rip), %rsi
        lea ram+256(%rip), %rdi
    
    character_loop:
        movb (%rsi), %al
        movb (%rdi), %bl
        
        xorb %bl, %al
        mov $8, %r8

    bit_loop:        
        testb $1, %al
        jz bit_is_zero
        inc %rcx

    bit_is_zero:
        shrb $1, %al
        dec %r8
        jnz bit_loop
    
        inc %rsi
        inc %rdi
        dec %rdx
        jnz character_loop

    mov %rcx, hamResult(%rip)
    ret

.section .note.GNU-stack,"",@progbits