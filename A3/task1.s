@ Assembler program for Task 1
.thumb_func
.global main

main:
    BL stdio_init_all   @ Initialize uart or usb
    BL average          @ Call average function
    B loop              @ Loop forever

average:
    MOV R7, #0
    LDR R0, =arr
    LDR R1, [R0, #(4*0)]
    LDR R2, [R0, #(4*1)]
    LDR R3, [R0, #(4*2)]
    LDR R4, [R0, #(4*3)]
    add r7, r7, r1
    add r7, r7, r2
    add r7, r7, r3
    add r7, r7, r4
    LDR R1, [R0, #(4*4)]
    LDR R2, [R0, #(4*5)]
    LDR R3, [R0, #(4*6)]
    LDR R4, [R0, #(4*7)]
    add r7, r7, r1
    add r7, r7, r2
    add r7, r7, r3
    add r7, r7, r4
    LSR r7, #3         @ Average calculation
    bx lr

loop:
    LDR R0, =message   @ Load address of message string
    MOV R1, R7         @ Move average value to R1
    BL printf          @ Call printf
    B loop             @ Loop forever

.data
    .align 4
    arr: .word 10, 20, 30, 40, 50, 60, 70, 80
    .align 4
    message: .asciz "Average value %d\n"
