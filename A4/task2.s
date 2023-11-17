@
@ Assembler program to flash binary
@ Raspberry Pi GPIO writing to the registers directly.
@
#include "hardware/regs/addressmap.h"
#include "hardware/regs/sio.h"
#include "hardware/regs/io_bank0.h"
#include "hardware/regs/timer.h"
#include "hardware/regs/pads_bank0.h"
#include "hardware/regs/m0plus.h"

.EQU RESET, 0
.EQU LED1, 1
.EQU LED2, 2
.EQU LED3, 3
.EQU LED4, 4
.EQU alarm0_isr_offset, 0x40

.thumb_func
.global main             @ Provide program starting address
.align 4                 @ necessary alignment

main:
    @ Init each of the three pins and set them to output
    MOV R0, #LED1
    BL gpioinit
    MOV R0, #LED2
    BL gpioinit
    MOV R0, #LED3
    BL gpioinit
    MOV R0, #LED4
    BL gpioinit
    MOV R0, #RESET
    BL gpioinit
    BL set_alarm0_isr
    LDR R0, alarmtime    @ load the time to sleep
    BL set_alarm0        @ set the first alarm

loop: 
    @ loop the button input check.
    MOV R0, #RESET
    BL gpio_read
    CMP R0, #1
    BEQ reset            @ if on, go to reset
    B loop

set_alarm0:
    @ Set's the next alarm on alarm 0
    @ R0 is the length of the alarm
    @ Enable timer 0 interrupt
    LDR R2, timerbase
    MOV R1, #1           @ for alarm 0
    STR R1, [R2, #TIMER_INTE_OFFSET]

    @ Set alarm
    LDR R1, [R2, #TIMER_TIMELR_OFFSET]
    ADD R1, R0
    STR R1, [R2, #TIMER_ALARM0_OFFSET]
    BX LR

reset: 
    @ Resets the state back to zero, returns to loop afterwards
    MOV R3, #0           @ set state back to zero
    LDR R2, =state       @ load address of state
    STR R3, [R2]         @ save state == 0
    B loop

.thumb_func              @ necessary for interrupt handlers
@ Alarm 0 interrupt handler and state machine.
alarm_isr:
    PUSH {LR}            @ calls other routines
    @ Clear the interrupt
    LDR R2, timerbase
    MOV R1, #1           @ for alarm 0
    STR R1, [R2, #TIMER_INTR_OFFSET]

    @ Disable/enable LEDs based on state
    LDR R2, =state       @ load address of state
    LDR R3, [R2]
    MOV R0, #1
    ADD R3, R0
    STR R3, [R2]         @ load value of state
                         @ increment state
                         @ save state

    @ [State Machine Logic with steps and finish label]

    LDR R0, alarmtime    @ load sleep time
    BL set_alarm0        @ set next alarm
    POP {PC}             @ return from interrupt

set_alarm0_isr:
    @ Set IRQ Handler to our routine
    LDR R2, ppbbase
    LDR R1, vtoroffset
    ADD R2, R1
    LDR R1, [R2]
    MOV R2, #alarm0_isr_offset
    ADD R2, R1
    LDR R0, =alarm_isr
    STR R0, [R2]

    @ Enable alarm 0 IRQ (clear then set)
    MOV R0, #1           @ alarm 0 is IRQ0
    LDR R2, ppbbase
    LDR R1, clearint
    ADD R1, R2
    STR R0, [R1]
    LDR R1, setint
    ADD R1, R2
    STR R0, [R1]
    BX LR

    @ [Other Initialization and Control Functions for GPIO and Timers]

.data
state: .word 0